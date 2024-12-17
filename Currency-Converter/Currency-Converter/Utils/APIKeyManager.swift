//
//  Untitled.swift
//  Currency-Converter
//
//  Created by Minh Trương on 17/12/24.
//

import Foundation

class APIKeyManager {
    static let shared = APIKeyManager()
    var apiKey: String {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) {
            return dict["API_KEY"] as? String ?? ""
        }
        return ""
    }
}
