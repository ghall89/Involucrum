import SwiftUI

struct ContentView: View {
	@State private var packageJSONData: PackageJson?
	@State private var webviewURL: URL?
	
	private func setURL(npmName: String) {
		webviewURL = URL(string: "https://www.npmjs.com/package/\(npmName)")
	}
	
	var body: some View {
		HStack {
			VStack {
				List {
					Section("Name") {
						Text(packageJSONData?.name ?? "n/a")
					}
					
					Section("Version") {
						Text(packageJSONData?.version ?? "n/a")
					}
					
					Section("Scripts") {
						ForEach(packageJSONData?.scripts?.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { script in
							Text("\(script.key): \(script.value)")
						}
					}
					
					Section("Dependencies") {
						ForEach(packageJSONData?.dependencies?.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { dependency in
							Button(action: {
								setURL(npmName: dependency.key)
							}, label: {
								Text("\(dependency.key): \(dependency.value)")
							})
							.buttonStyle(.plain)
						}
						
					}
					
					Section("Dev Dependencies") {
						ForEach(packageJSONData?.devDependencies?.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { devDependency in
							Button(action: {
								setURL(npmName: devDependency.key)
							}, label: {
								Text("\(devDependency.key): \(devDependency.value)")
							})
							.buttonStyle(.plain)
						}
					}
				}
			}
			.frame(width: 220)
			
			VStack {
				if webviewURL != nil {
					WebView(url: $webviewURL)
				}
			}
			.frame(maxWidth: .infinity)
		}
		.toolbar(content: {
			ToolbarItem(content: {
				Button(action: {
					let openPanel = NSOpenPanel()
					openPanel.allowedContentTypes = [.json]
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
