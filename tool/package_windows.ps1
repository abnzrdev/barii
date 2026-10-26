param(
    [string]$ReleaseDirectory = 'build/windows/x64/runner/Release',
    [string]$Output = 'build/barii-0.2.0-beta.1-windows-x64.zip'
)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.IO.Compression
$releasePath = (Resolve-Path -LiteralPath $ReleaseDirectory).Path
$manifestPath = Join-Path $releasePath 'data/flutter_assets/assets/dictionary/manifest.json'
$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
$packPath = Join-Path $releasePath 'data/flutter_assets/assets/dictionary/english.sqlite.gz'
if ((Get-FileHash -LiteralPath $packPath -Algorithm SHA256).Hash.ToLowerInvariant() -ne $manifest.asset_sha256) {
    throw 'Release dictionary does not match its manifest.'
}
$outputPath = [IO.Path]::GetFullPath($Output)
$archive = [IO.Compression.ZipFile]::Open($outputPath, [IO.Compression.ZipArchiveMode]::Create)
try {
    $files = @(Get-Item -LiteralPath (Join-Path $releasePath 'barii.exe'))
    $files += @(Get-ChildItem -LiteralPath $releasePath -Filter '*.dll' -File)
    $files += @(Get-ChildItem -LiteralPath (Join-Path $releasePath 'data') -Recurse -File)
    foreach ($file in $files) {
        $relative = $file.FullName.Substring($releasePath.Length + 1).Replace('\', '/')
        [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $relative, [IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
    foreach ($document in @(
        @('LICENSE', 'LICENSE'), @('NOTICE', 'NOTICE'),
        @('docs/install-windows.txt', 'README-WINDOWS.txt'),
        @('docs/dictionary.md', 'DICTIONARY.md')
    )) {
        [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, (Resolve-Path -LiteralPath $document[0]).Path, $document[1]) | Out-Null
    }
} finally {
    $archive.Dispose()
}
Get-Item -LiteralPath $outputPath | Select-Object FullName, Length
Get-FileHash -LiteralPath $outputPath -Algorithm SHA256
