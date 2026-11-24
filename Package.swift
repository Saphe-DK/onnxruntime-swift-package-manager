// swift-tools-version: 5.9

// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
//
// Saphe's copy of microsoft/onnxruntime-swift-package-manager 1.24.2. See README.md for what differs.

import PackageDescription

let package = Package(
    name: "onnxruntime",
    platforms: [.iOS(.v15),
                .macOS(.v14)],
    products: [
        .library(name: "onnxruntime",
                 type: .static,
                 targets: ["OnnxRuntimeBindings"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "OnnxRuntimeBindings",
                dependencies: ["onnxruntime"],
                path: "objectivec",
                exclude: ["ReadMe.md", "format_objc.sh", "test", "docs",
                            "ort_checkpoint.mm",
                            "ort_checkpoint_internal.h",
                            "ort_training_session_internal.h",
                            "ort_training_session.mm",
                            "include/ort_checkpoint.h",
                            "include/ort_training_session.h",
                            "include/onnxruntime_training.h"],
                cxxSettings: [
                    .define("SPM_BUILD"),
                ]),
        .testTarget(name: "OnnxRuntimeBindingsTests",
                    dependencies: ["OnnxRuntimeBindings"],
                    path: "swift/OnnxRuntimeBindingsTests",
                    resources: [
                        .copy("Resources/single_add.basic.ort")
                    ]),
        // Made by scripts/repackage.sh from pod-archive-onnxruntime-c-1.24.2.zip.
        .binaryTarget(name: "onnxruntime",
                      url: "https://github.com/Saphe-DK/onnxruntime-swift-package-manager/releases/download/1.24.2/onnxruntime.xcframework.zip",
                      checksum: "aaf1e5c20090264e2adcf4720faf6c7b4c8bbbc77449c34dc0c203e9bbf21100"),
    ],
    cxxLanguageStandard: .cxx17
)
