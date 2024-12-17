//
//  File.swift
//  Currency-Converter
//
//  Created by Minh Trương on 14/12/24.
//

import Foundation

struct ExchangeRate: Codable {
    var success: Bool
    var error: ErrorDetails?
    var timestamp: Int?
    var base: String?
    var date: String?
    var rates: [String: Double]?
}

struct ErrorDetails: Codable {
    var code: Int
    var type: String
    var info: String
}
