import SwiftUI
import Markdown

struct ContentView: View {
	@EnvironmentObject var observableNodeProject: ObservableNodeProject
	
	@State private var readMe: String = "#Hello World"
	
	@State private var showSheet: Bool = false
	@State private var showAlert: Bool = false
	
	var body: some View {
		
		HStack {
			if observableNodeProject.projectLocation != nil && observableNodeProject.packageJSONData != nil {
				VStack {
					DetailsListView(data: $observableNodeProject.packageJSONData, readMe: $readMe)
				}
				.frame(width: 220)
				
				VStack {
					Markdown(content: $readMe)
				}
				.frame(maxWidth: .infinity)
			} else {
				VStack {
					Button(action: {
						let openPanel = NSOpenPanel()
						openPanel.canChooseDirectories = true
						openPanel.canChooseFiles = false
						openPanel.begin { response in
							if response == .OK {
								if let url = openPanel.urls.first {
									do {
										observableNodeProject.projectLocation = url
										let packageJSONPath = URL(filePath: "package.json", relativeTo: url)
										let packageJSON = try Data(contentsOf: packageJSONPath)
										let decoder = JSONDecoder()
										
										do {
											observableNodeProject.packageJSONData = try decoder.decode(PackageJson.self, from: packageJSON)
										}
									} catch {
										print("Error loading package.json:", error)
										showAlert.toggle()
									}
								}
							}
						}
					}, label: {
						Text("Open Node Project")
					})
				}
			}
		}
		.toolbar(content: {
						ToolbarItem(content: {
							Menu(content: {
								Button("Add Dependency", action: {
									
								})
								Button("Add Dev Dependency", action: {
									
								})
							}, label: {
								Image(systemName: "plus")
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
