// LoginView.swift
import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showError: Bool = false
    
    var body: some View {
        if isLoggedIn {
            let baseURL = "http://\(username):\(password)@try.axxonsoft.com:8000/asip-api"
            TabView {
                CameraListView(baseURL: baseURL)
                    .tabItem {
                        Label("Cameras", systemImage: "video")
                    }
                
                EventsView(baseURL: baseURL)
                    .tabItem {
                        Label("Events", systemImage: "bell")
                    }
            }
        } else {
            VStack(spacing: 20) {
                Text("Вход в систему")
                    .font(.title)
                
                TextField("Логин", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("Пароль", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Войти") {
                    checkLogin()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                if showError {
                    Text("Неверный логин или пароль")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .ignoresSafeArea(.keyboard)
        }
    }
    
    func checkLogin() {
        let baseURL = "http://\(username):\(password)@try.axxonsoft.com:8000/asip-api"
        guard let url = URL(string: baseURL) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200 {
                        isLoggedIn = true
                        showError = false
                    } else {
                        showError = true
                    }
                }
            }
        }
        task.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
