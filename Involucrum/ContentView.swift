import SwiftUI

struct ContentView: View {
	@State private var packageJSONData: PackageJson?
	
	var body: some View {
		VStack {
			List {
				Section("Name") {
					Text(packageJSONData?.name ?? "n/a")
				}
				
				Section("Version") {
					Text(packageJSONData?.version ?? "n/a")
				}
				
				Section("Scripts") {
					ForEach(packageJSONData?.scripts.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { script in
						Text("\(script.key): \(script.value)")
					}
				}
				
				Section("Dependencies") {
					ForEach(packageJSONData?.dependencies.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { dependency in
						Text("\(dependency.key): \(dependency.value)")
					}
				}
				
				Section("Dev Dependencies") {
					ForEach(packageJSONData?.devDependencies.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { devDependency in
						Text("\(devDependency.key): \(devDependency.value)")
					}
				}
			}
		}
		.toolbar(content: {
			ToolbarItem(content: {
				Button(action: {
					let openPanel = NSOpenPanel()
					openPanel.allowedFileTypes = ["json"]
					openPanel.begin { response in
						if response == .OK {
							if let url = openPanel.urls.first {
								do {
									let packageJSON = try Data(contentsOf: url)
									
									let decoder = JSONDecoder()
									
									do {
										packageJSONData = try decoder.decode(PackageJson.self, from: packageJSON)
									}
								} catch {
									print("Error loading package.json:", error)
								}
							}
						}
					}
				}, label: {
					Image(systemName: "shippingbox")
				})
			})
		})
	}
}
