// EventDetailView.swift
import SwiftUI

struct EventDetailView: View {
    let event: Event
    let baseURL: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Детали события")
                .font(.title)
            
            Text("ID: \(event.id)")
            Text("Тип: \(event.type)")
            Text("Камера: \(event.displayId)")
            Text("Состояние: \(event.alertState)")
            Text("Время: \(event.timestamp)")
            
            if let snapshotURL = event.snapshotURL(baseURL: baseURL) {
                AsyncImage(url: snapshotURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Text("Не удалось загрузить снимок")
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Детали")
    }
}

