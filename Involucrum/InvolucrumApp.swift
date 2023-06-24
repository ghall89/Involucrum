//
//  InvolucrumApp.swift
//  Involucrum
//
//  Created by Graham Hall on 6/18/23.
//

import SwiftUI

@main
struct InvolucrumApp: App {
	
	@StateObject var observableNodeProject = ObservableNodeProject()
	
	var body: some Scene {
		WindowGroup {
			ContentView()
				.frame(minWidth: 800, minHeight: 460)
				.environmentObject(observableNodeProject)
		}
	}
}
