//
//  CurrencyConverterViewModel.swift
//  Currency-Converter
//
//  Created by Minh Trương on 14/12/24.
//

import Foundation

class CurrentCurrencyConverterViewModel: ObservableObject {
    @Published var inputAmount: String = ""
    @Published var convertedAmount: String = ""
    @Published var base: String = "SGD"
    @Published var nextTarget: String = "USD"
    @Published var conversionRate: Double? = 0.0
    @Published var errorMessage: String?
    
    init() {
//        fetchCurrentCurrencyConversion()
    }
    
    private let apiURL: String = "https://api.exchangeratesapi.io/latest"
    
    func fetchCurrentCurrencyConversion() {
        guard let url = URL(string: apiURL) else {
            self.errorMessage = "URL is not valid"
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                self.errorMessage = "Failed to receive data"
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ExchangeRate.self, from: data)
                self.base = response.base
                self.nextTarget = response.base
            }
            catch {
                self.errorMessage = "Failed to decode data"
            }
        }
        
    }
}

extension CurrentCurrencyConverterViewModel{
    func emojiFlag(_ currencyCode: String) -> String{
        guard let country = Country.getCountryByCode(code : currencyCode) else {
            return currencyCode
                .dropLast()
                .unicodeScalars
                .map({127397 + $0.value})
                .compactMap(UnicodeScalar.init)
                .map(String.init)
                .joined()
        }
        return country.countryFlag
    }
    
    
}
