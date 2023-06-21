import SwiftUI

struct AddDependencyView: View {
	@State private var input: String = ""
	
	var body: some View {
		VStack {
			TextField("Package Name", text: $input)
			Button("Add", action: {
				executeCommand(command: "npm install \(input)")
				
			})
		}
		.padding()
	}
}
