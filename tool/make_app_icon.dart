import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

void main() {
  File(
    'windows/runner/resources/app_icon.png',
  ).writeAsBytesSync(img.encodePng(_mark(1024)));

  const android = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
  };
  for (final entry in android.entries) {
    final file = File('android/app/src/main/res/${entry.key}/ic_launcher.png');
    file.writeAsBytesSync(img.encodePng(_mark(entry.value)));
  }

  const icoSizes = [16, 24, 32, 48, 64, 128, 256];
  final pngs = {
    for (final size in icoSizes)
      size: Uint8List.fromList(img.encodePng(_mark(size))),
  };
  File('windows/runner/resources/app_icon.ico').writeAsBytesSync(_ico(pngs));
}

int _rgb(int red, int green, int blue) => img.Color.fromRgb(red, green, blue);

img.Image _mark(int size) {
  final canvas = img.Image(size, size);
  final ink = _rgb(0x2d, 0x33, 0x21);
  final paper = _rgb(0xf4, 0xf1, 0xea);
  final page = _rgb(0xe7, 0xe1, 0xd4);
  final sage = _rgb(0x7f, 0xa8, 0x6a);
  img.fill(canvas, ink);

  final left = (size * 0.18).round();
  final right = (size * 0.82).round();
  final top = (size * 0.16).round();
  final bottom = (size * 0.84).round();
  final mid = size ~/ 2;
  final radius = (size * 0.04).round().clamp(1, 48);
  _roundRect(canvas, left, top, right, bottom, radius, paper);
  _roundRect(canvas, mid, top, right, bottom, radius, page);
  final spine = (size * 0.025).round().clamp(1, 28);
  img.fillRect(canvas, mid - spine, top, mid + spine, bottom, ink);
  final markW = (size * 0.07).round().clamp(1, 72);
  final markH = (size * 0.28).round();
  img.fillRect(
    canvas,
    mid + spine * 2,
    top,
    mid + spine * 2 + markW,
    top + markH,
    sage,
  );
  return canvas;
}

void _roundRect(
  img.Image canvas,
  int x1,
  int y1,
  int x2,
  int y2,
  int radius,
  int color,
) {
  img.fillRect(canvas, x1 + radius, y1, x2 - radius, y2, color);
  img.fillRect(canvas, x1, y1 + radius, x2, y2 - radius, color);
  img.fillCircle(canvas, x1 + radius, y1 + radius, radius, color);
  img.fillCircle(canvas, x2 - radius, y1 + radius, radius, color);
  img.fillCircle(canvas, x1 + radius, y2 - radius, radius, color);
  img.fillCircle(canvas, x2 - radius, y2 - radius, radius, color);
}

Uint8List _ico(Map<int, Uint8List> pngs) {
  final sizes = pngs.keys.toList()..sort();
  final bytes = BytesBuilder();
  bytes.add(const [0, 0, 1, 0]);
  bytes.add([sizes.length, 0]);
  var offset = 6 + (16 * sizes.length);
  final body = BytesBuilder();
  for (final size in sizes) {
    final png = pngs[size]!;
    bytes.add([
      size >= 256 ? 0 : size,
      size >= 256 ? 0 : size,
      0,
      0,
      1,
      0,
      32,
      0,
    ]);
    bytes.add(_u32(png.length));
    bytes.add(_u32(offset));
    body.add(png);
    offset += png.length;
  }
  bytes.add(body.toBytes());
  return bytes.toBytes();
}

List<int> _u32(int value) => [
  value & 0xff,
  (value >> 8) & 0xff,
  (value >> 16) & 0xff,
  (value >> 24) & 0xff,
];
