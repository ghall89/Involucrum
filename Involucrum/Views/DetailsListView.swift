import SwiftUI

struct DetailsListView: View {
	@EnvironmentObject var observableNodeProject: ObservableNodeProject
	
	@Binding var data: PackageJson?
	@Binding var readMe: String
	
	private func setReadMe(npmName: String) {
		let readMePath = URL(filePath: "node_modules/\(npmName)/README.md", relativeTo: observableNodeProject.projectLocation)
		do {
			readMe = try String(contentsOf: readMePath)
			print(readMe)
		} catch {
			print("Error loading readme:", error)
		}
	}
	
	var body: some View {
		List {
			Section("Name") {
				Text(data?.name ?? "")
			}
			
			Section("Version") {
				Text(data?.version ?? "")
			}
			
			Section("Scripts") {
				ForEach(data?.scripts?.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { script in
					Text("\(script.key): \(script.value)")
				}
			}
			
			Section("Dependencies") {
				ForEach(data?.dependencies?.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { dependency in
					Button(action: {
						setReadMe(npmName: dependency.key)
					}, label: {
						Text("\(dependency.key): \(dependency.value)")
					})
					.buttonStyle(.plain)
				}
				
			}
			
			Section("Dev Dependencies") {
				ForEach(data?.devDependencies?.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { devDependency in
					Button(action: {
						setReadMe(npmName: devDependency.key)
					}, label: {
						Text("\(devDependency.key): \(devDependency.value)")
					})
					.buttonStyle(.plain)
				}
			}
		}
	}
}
