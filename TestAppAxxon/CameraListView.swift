// CameraListView.swift
import SwiftUI

struct CameraListView: View {
    @State private var cameras: [Camera] = []
    @State private var searchText: String = ""
    @State private var sortAscending: Bool = true
    let baseURL: String
    
    var filteredAndSortedCameras: [Camera] {
        let filtered = searchText.isEmpty ? cameras : cameras.filter { camera in
            camera.displayName.lowercased().contains(searchText.lowercased())
        }
        return filtered.sorted { sortAscending ? $0.displayName < $1.displayName : $0.displayName > $1.displayName }
    }
    
    var body: some View {
        NavigationView { // Оставляем один NavigationView для навигации к деталям
            VStack {
                TextField("Поиск по названию", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Spacer()
                    Button(action: { sortAscending.toggle() }) {
                        Image(systemName: sortAscending ? "arrow.up" : "arrow.down")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                
                List(filteredAndSortedCameras) { camera in
                    NavigationLink(
                        destination: CameraDetailView(camera: camera, baseURL: baseURL),
                        label: {
                            Text(camera.displayName)
                        }
                    )
                }
            }
            .navigationTitle("Cameras")
            .onAppear {
                fetchCameras()
            }
        }
    }
    
    func fetchCameras() {
        guard let url = URL(string: "\(baseURL)/camera/list?filter=DEMOSERVER") else {
            print("Неверный URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка при загрузке: \(error)")
                return
            }
            
            guard let data = data else {
                print("Нет данных")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let cameraResponse = try decoder.decode(CameraResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.cameras = cameraResponse.cameras
                }
            } catch {
                print("Ошибка декодирования: \(error)")
            }
        }
        task.resume()
    }
}

struct CameraListView_Previews: PreviewProvider {
    static var previews: some View {
        CameraListView(baseURL: "http://test:test@try.axxonsoft.com:8000/asip-api")
    }
}
