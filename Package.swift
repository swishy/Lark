import PackageDescription

let package = Package(
    name: "Lark",
    targets: [
        Target(name: "CodeGenerator", dependencies: ["SchemaParser"]),
        Target(name: "soap-generate-code", dependencies: ["SchemaParser", "CodeGenerator"]),
        Target(name: "Demo", dependencies: ["LarkRuntime"]),
    ],
    dependencies: [
        .Package(url: "https://github.com/Bouke/Evergreen.git", majorVersion: 0),
    ]
)