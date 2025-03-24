//
//  Camera.swift
//  TestAppAxxon
//
//  Created by Stepashka Igorevich on 24.03.25.
//

// Camera.swift
import Foundation

struct Camera: Codable, Identifiable {
    let id = UUID()
    let displayName: String
    let displayId: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "displayName"
        case displayId = "displayId"
    }
}

struct CameraResponse: Codable {
    let cameras: [Camera]
}
