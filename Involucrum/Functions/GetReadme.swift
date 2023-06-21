import Foundation

func getReadme(packageName: String, completion: @escaping (Result<Data, Error>) -> Void) {
	let npmRegistryURL = "https://registry.npmjs.org/"
	
	guard let url = URL(string: npmRegistryURL + packageName) else {
		print("Invalid URL")
		return
	}
	
	let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
		if let error = error {
			print("Error: \(error.localizedDescription)")
			return
		}
		
		guard let data = data else {
			print("No data received")
			return
		}
		
		do {
			if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
				 let latestVersion = json["dist-tags"] as? [String: Any],
				 let latestVersionNumber = latestVersion["latest"] as? String,
				 let versions = json["versions"] as? [String: Any],
				 let versionDetails = versions[latestVersionNumber] as? [String: Any],
				 let readmeURL = versionDetails["readme"] as? String {
				
				guard let readmeURL = URL(string: readmeURL) else {
					print("Invalid README URL")
					return
				}
				
				let readmeTask = URLSession.shared.dataTask(with: readmeURL) { (readmeData, _, _) in
					if let readmeData = readmeData,
						 let readme = String(data: readmeData, encoding: .utf8) {
						print(readme)
					} else {
						print("Failed to fetch README")
					}
				}
				
				readmeTask.resume()
			} else {
				print("Readme not found")
			}
		} catch {
			print("Error decoding JSON: \(error.localizedDescription)")
		}
	}
	
	task.resume()
}
