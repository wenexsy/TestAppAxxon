//
//  WebView.swift
//  TestAppAxxon
//
//  Created by Stepashka Igorevich on 24.03.25.
//


// CameraDetailView.swift
import SwiftUI
import WebKit


struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

struct CameraDetailView: View {
    let camera: Camera
    let baseURL: String
    
    var streamURL: URL? {
        let urlString = "\(baseURL)/live/media/DEMOSERVER/DeviceIpint.\(camera.displayId)/SourceEndpoint.video:0:0?w=0&h=0"
        return URL(string: urlString)
    }
    
    var body: some View {
        VStack {
            if let streamURL = streamURL {
                WebView(url: streamURL)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Не удалось сформировать URL стрима")
            }
            
            Text("Название: \(camera.displayName)")
                .padding()
        }
        .navigationTitle("Детали камеры")
    }
}

struct CameraDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CameraDetailView(
            camera: Camera(displayName: "Test Camera", displayId: "6"),
            baseURL: "http://test:test@try.axxonsoft.com:8000/asip-api"
        )
    }
}
