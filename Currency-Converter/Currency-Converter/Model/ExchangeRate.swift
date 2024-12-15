//
//  File.swift
//  Currency-Converter
//
//  Created by Minh Trương on 14/12/24.
//

import Foundation

struct ExchangeRate: Codable, Identifiable, Equatable{
    var id = UUID()
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String?
    var rates: [String: Double]?
    
}
