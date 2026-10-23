import SwiftUI
import WebKit

struct WebViewContainer: UIViewRepresentable {
    let targetURL: URL

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.javaScriptEnabled = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.scrollView.bounces = true
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.allowsBackForwardNavigationGestures = true
        
        let request = URLRequest(url: targetURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15.0)
        webView.load(request)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewContainer

        init(_ parent: WebViewContainer) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("WebView navigation error: \(error.localizedDescription)")
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("WebView provisional failure: \(error.localizedDescription)")
        }
    }
}

struct ContentView: View {
    private let serverURL = URL(string: "http://192.168.1.239:8080/Ebanking.html")!

    var body: some View {
        ZStack {
            Color(red: 2/255, green: 6/255, blue: 23/255)
                .edgesIgnoringSafeArea(.all)
            WebViewContainer(targetURL: serverURL)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
