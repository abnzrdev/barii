# Original EPUB view design

BookBites remains the default reader. Original EPUB view is an optional,
per-book reflowable rendering of managed EPUB resources.

The view uses the cross-platform `webview_all` surface on Android and Linux.
An ephemeral Dart HTTP server binds only to loopback and exposes one random
publication origin. Requests are accepted only for normalized archive paths
listed in the EPUB. Responses add a restrictive Content Security Policy:
publisher scripts, network connections, frames, objects and form actions are
disabled. File URLs and traversal never reach the filesystem. Main-frame
navigation outside the publication origin is blocked; http(s) links require
explicit user confirmation before opening in the system browser.

The original view loads one spine occurrence at a time. Host-controlled
relocation reports the nearest element ID and logical text offset. Switching
views resolves that location through the canonical projection and retains the
existing bite ID plus source offset as the authoritative legacy location.
Original view preference is stored per book in an additive table. Fixed-layout
and scripted publications are detected and rejected explicitly in this phase.

Readest 6469cbb5b5799912b6376765d57175f5552eedf7 and its pinned Foliate-js
f6bce4ce81d7cc6cd5df156a9867e3f0daa0427c informed section-scoped loading,
relocation independent of display pages, and deterministic teardown. No source
was copied or translated.
