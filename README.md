# HEIC to JPEG Converter

A native macOS app for batch converting HEIC images to JPEG — fast, private, and free.

<p align="center">
  <img src="screenshots/Light.png" width="420" alt="Light mode">
  &nbsp;&nbsp;
  <img src="screenshots/Dark.png" width="420" alt="Dark mode">
</p>

## Features

- **Drag & drop** — drop files or entire folders, conversion starts automatically
- **Batch conversion** — processes multiple images concurrently
- **JPEG quality control** — slider to balance file size and image quality
- **Custom save location** — choose any output folder
- **Completion notifications** — get notified when a batch finishes
- **100% offline** — no internet connection, no cloud upload, no tracking
- **App Sandbox** — sandboxed with user-selected file access only

## Download

Grab the latest `.dmg` from the [Releases](../../releases) page.

> **Note:** The app is ad-hoc signed (no Apple Developer account). On first launch macOS Gatekeeper will block it. To open it:
> 1. Right-click `HEIC to JPEG.app` → **Open** → **Open** again in the dialog
>
> Or via Terminal:
> ```bash
> sudo xattr -rd com.apple.quarantine "/Applications/HEIC to JPEG Converter.app"
> ```

## Building from Source

### Requirements

- macOS 15.0 (Sequoia) or later
- Xcode 26+

## Architecture

```
HEICConverter/
├── Models/
│   ├── ConversionError.swift
│   ├── ConversionItem.swift
│   ├── ConversionResult.swift
│   └── ConversionSettings.swift
├── Services/
│   ├── FileSystemService.swift        # actor — file I/O
│   ├── ImageConversionService.swift   # struct — HEIC → JPEG conversion
│   └── NotificationService.swift      # user notifications
├── ViewModels/
│   ├── ConversionViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── HomeView.swift
│   ├── DropZoneView.swift
│   ├── ConversionListView.swift
│   ├── ConversionItemRow.swift
│   ├── FooterView.swift
│   └── Settings/
└── Util/
    ├── GlassStyle.swift
    └── Extensions/
```

- **Swift 6 / SwiftUI** — 100% SwiftUI interface
- **MVVM** — `ConversionViewModel` and `SettingsViewModel` drive the UI
- **Swift Concurrency** — structured task groups for parallel conversion
- **Actor isolation** — `FileSystemService` actor; project-wide `@MainActor` default isolation via `SWIFT_DEFAULT_ACTOR_ISOLATION`

## License

MIT 

---

Built by [Anton Paliakou](https://github.com/Toni77777)
