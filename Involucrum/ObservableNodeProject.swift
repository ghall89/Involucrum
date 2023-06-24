import Foundation

class ObservableNodeProject: ObservableObject {
	@Published var projectLocation: URL?
	@Published var packageJSONData: PackageJson?
}
