import SwiftUI
import Markdown

struct ContentView: View {
	@State private var projectLocation: URL?
	@State private var packageJSONData: PackageJson?

	@State private var readMe: String = "#Hello World"
	@State private var showSheet: Bool = false
	@State private var showAlert: Bool = false
	
	var body: some View {
		
		HStack {
			if projectLocation != nil && packageJSONData != nil {
				VStack {
					DetailsListView(data: $packageJSONData, readMe: $readMe)
				}
				.frame(width: 220)
				
				VStack {
					ScrollView {
						Markdown(content: $readMe)
					}
				}
				.frame(maxWidth: .infinity)
			} else {
				VStack {
					Text("No project loaded...")
				}
			}
		}
		.toolbar(content: {
//			ToolbarItem(content: {
//				Menu(content: {
//					Button("Add Dependency", action: {
//						showSheet = true
//					})
//					Button("Add Dev Dependency", action: {})
//				}, label: {
//					Image(systemName: "plus")
//				})
//			})
			ToolbarItem(content: {
				Button(action: {
					let openPanel = NSOpenPanel()
					openPanel.canChooseDirectories = true
					openPanel.canChooseFiles = false
					openPanel.begin { response in
						if response == .OK {
							if let url = openPanel.urls.first {
								do {
									projectLocation = url
									let packageJSONPath = URL(filePath: "package.json", relativeTo: url)
									let packageJSON = try Data(contentsOf: packageJSONPath)
									let decoder = JSONDecoder()
									
									do {
										packageJSONData = try decoder.decode(PackageJson.self, from: packageJSON)
									}
								} catch {
									print("Error loading package.json:", error)
									showAlert.toggle()
								}
							}
						}
					}
				}, label: {
					Image(systemName: "shippingbox")
				})
			})
		})
		.sheet(isPresented: $showSheet, content: {
			AddDependencyView()
		})
		.alert("No valid 'package.json' found.", isPresented: $showAlert, actions: {
			Button("OK", action: {
				showAlert.toggle()
			})
		})
	}
}
