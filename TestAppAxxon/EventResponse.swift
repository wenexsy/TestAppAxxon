//
//  EventResponse.swift
//  TestAppAxxon
//
//  Created by Stepashka Igorevich on 24.03.25.
//


// Event.swift
import Foundation

struct EventResponse: Codable {
    let events: [Event]
    let more: Bool
}

struct Event: Codable, Identifiable {
    let id: String
    let alertState: String
    let origin: String
    let source: String
    let timestamp: String
    let type: String
    let multiPhaseSyncId: String?
    
    var displayId: String {
        let components = source.split(separator: ".")
        return String(components[1])

    }
    
    func snapshotURL(baseURL: String) -> URL? {
        let urlString = "\(baseURL)/live/media/DEMOSERVER/DeviceIpint.\(displayId)/SourceEndpoint.video:0:0/\(timestamp)"
        print("\(urlString)")

        return URL(string: urlString)
    }
}
