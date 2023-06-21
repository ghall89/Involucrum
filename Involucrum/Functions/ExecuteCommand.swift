import Foundation

func executeCommand(command: String) {
	let task = Process()
	
	task.arguments = ["bash", "-c", command]
	
	let pipe = Pipe()
	task.standardOutput = pipe
	
	task.launch()
	
	let data = pipe.fileHandleForReading.readDataToEndOfFile()
	
	if let output = String(data: data, encoding: .utf8) {
		print(output)
	}
	
	task.waitUntilExit()
}
