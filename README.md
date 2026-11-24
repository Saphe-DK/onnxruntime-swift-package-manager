# onnxruntime-swift-package-manager (Saphe copy)

A copy of [microsoft/onnxruntime-swift-package-manager](https://github.com/microsoft/onnxruntime-swift-package-manager) 1.24.2, the Swift package for [ONNX Runtime](https://onnxruntime.ai) on iOS, kept for the Saphe Link app. In November 2026 Microsoft's repository disappeared from GitHub, and download.onnxruntime.ai stopped serving the prebuilt library.

```swift
.package(url: "https://github.com/Saphe-DK/onnxruntime-swift-package-manager", exact: "1.24.2")
```

## Differences from upstream

- Only the `onnxruntime` product (the Objective-C bindings). The extensions are left out.
- The prebuilt library is the `onnxruntime.xcframework.zip` asset of this repository's 1.24.2 release. It is Microsoft's `pod-archive-onnxruntime-c-1.24.2.zip` (SHA-256 `f7100a992d2a8135168c8afd831e6a58b465349101982aa58b3e11d36e600b54`), repackaged by `scripts/repackage.sh` as a static-library XCFramework with unchanged object code. Microsoft's archive wraps the static library in a framework bundle, which Xcode embeds with a minimum iOS version that does not match its Info.plist, and App Store Connect rejects that (ITMS-90208).

## License

ONNX Runtime and these bindings are © Microsoft Corporation under the MIT License. See [LICENSE](LICENSE).
