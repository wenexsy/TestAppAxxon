// EventsView.swift
import SwiftUI

struct EventsView: View {
    @State private var events: [Event] = []
    @State private var searchCameraId: String = ""
    @State private var offset: Int = 0 
    @State private var isLoading: Bool = false
    let limit: Int = 5
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    var filteredEvents: [Event] {
        searchCameraId.isEmpty ? events : events.filter { $0.displayId.contains(searchCameraId) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Фильтр по ID камеры", text: $searchCameraId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    ForEach(filteredEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event, baseURL: baseURL)) {
                            VStack(alignment: .leading) {
                                Text("ID: \(event.id)")
                                    .font(.headline)
                                Text("Тип: \(event.type)")
                                Text("Камера: \(event.displayId)")
                                Text("Состояние: \(event.alertState)")
                                Text("Время: \(event.timestamp)")
                            }
                        }
                        .onAppear {
                            if event.id == filteredEvents.last?.id && !isLoading {
                                loadMoreEvents()
                            }
                        }
                    }
                    
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                }
            }
            .navigationTitle("Events")
            .onAppear {
                fetchEvents()
                Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                    fetchNewEvents()
                }
            }
        }
    }
    

    func fetchNewEvents() {
        guard let url = URL(string: "\(baseURL)/archive/events/detectors/DEMOSERVER/past/future?limit=\(limit)&offset=0") else {
            print("Неверный URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                do {
                    let decoder = JSONDecoder()
                    let eventResponse = try decoder.decode(EventResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        let newEvents = eventResponse.events.filter { newEvent in
                            !self.events.contains { $0.id == newEvent.id }
                        }
                        if !newEvents.isEmpty {
                            self.events = (newEvents + self.events).sorted { $0.timestamp < $1.timestamp }
                        }
                    }
                } catch {
                    print("Ошибка декодирования: \(error)")
                }
            }
        }.resume()
    }
    

    func fetchEvents() {
        guard !isLoading else { return }
        isLoading = true
        
        guard let url = URL(string: "\(baseURL)/archive/events/detectors/DEMOSERVER/past/future?limit=\(limit)&offset=\(offset)") else {
            print("Неверный URL")
            isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                do {
                    let decoder = JSONDecoder()
                    let eventResponse = try decoder.decode(EventResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        let newEvents = eventResponse.events.filter { newEvent in
                            !self.events.contains { $0.id == newEvent.id }
                        }
                        self.events.append(contentsOf: newEvents)
                        self.offset += newEvents.count
                        self.isLoading = false
                    }
                } catch {
                    print("Ошибка декодирования: \(error)")
                    self.isLoading = false
                }
            } else {
                print("Ошибка загрузки: \(error?.localizedDescription ?? "Нет данных")")
                self.isLoading = false
            }
        }.resume()
    }
    
    func loadMoreEvents() {
        fetchEvents()
    }
}

