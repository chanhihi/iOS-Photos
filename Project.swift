import ProjectDescription

let settings = Settings.settings(
    base: [
        "DEVELOPMENT_TEAM": "$(DEVELOPMENT_TEAM)",
    ],
    configurations: [
        .debug(name: "Debug", xcconfig: "Configurations/Debug.xcconfig"),
        .release(name: "Release", xcconfig: "Configurations/Release.xcconfig")
    ],
    defaultSettings: .recommended
)

let project = Project(
    name: "iOSPhotos",
    settings: settings,
    targets: [
        .target(
            name: "iOSPhotos",
            destinations: .iOS,
            product: .app,
            productName: "iOSPhotosKCH",
            bundleId: "io.tuist.iOSPhotos",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .file(path: "Configurations/info.plist"),
            sources: ["iOSPhotos/Sources/**"],
            resources: ["iOSPhotos/Resources/**"],
            dependencies: [
                .sdk(name: "PhotosUI", type: .framework, status: .required)
            ]
        ),
        .target(
            name: "iOSPhotosTests",
            destinations: .iOS,
            product: .unitTests,
            productName: "iOSPhotosKCHTests",
            bundleId: "io.tuist.iOSPhotosTests",
            infoPlist: .default,
            sources: ["iOSPhotos/Tests/**"],
            resources: [],
            dependencies: [.target(name: "iOSPhotos")]
        ),
    ]
)
