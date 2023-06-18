import Foundation

struct PackageJson: Codable {
	var name: String
	var version: String
	var scripts: [String: String]
	var dependencies: [String: String]
	var devDependencies: [String: String]
}
