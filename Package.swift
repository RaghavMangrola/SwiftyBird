import PackageDescription

let package = Package(
  name: "SwiftyBird",
  dependencies: [
    .Package(url: "https://github.com/pvzig/SlackKit.git", majorVersion: 3)
  ]
)
