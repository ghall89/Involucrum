import WebKit
import SwiftUI

struct WebView: NSViewRepresentable {
	@Binding var url: URL?
	
	func makeNSView(context: Context) -> WKWebView {
		let webView = WKWebView()
		
		if let urlRequest = URLRequest(url: url!) as URLRequest? {
			webView.load(urlRequest)
		}
		
		return webView
	}
	
	func updateNSView(_ nsView: WKWebView, context: Context) {
		guard let url = url else { return }
		
		let urlRequest = URLRequest(url: url)
		nsView.load(urlRequest)
	}
}



