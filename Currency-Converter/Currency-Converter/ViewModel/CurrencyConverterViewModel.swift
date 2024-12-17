//
//  CurrencyConverterViewModel.swift
//  Currency-Converter
//
//  Created by Minh Trương on 14/12/24.
//

import Foundation

@MainActor
class CurrentCurrencyConverterViewModel: ObservableObject {
    @Published var inputAmount: String = "100"
    @Published var convertedAmount: String = ""
    @Published var base: String = "USD"
    @Published var baseCode: String = "US"
    @Published var nextTarget: String = "VND"
    @Published var nextTargetCode: String = "VN"
    @Published var conversionRate: Double? = 0.0
    @Published var errorMessage: String = ""{
        didSet {
            showError = !errorMessage.isEmpty
            isLoading = false
        }
    }
    @Published var showError: Bool = false
    @Published var isLoading: Bool = false
    
    private let apiKey = APIKeyManager.shared.apiKey
    private let apiURL: String
    private var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared, testAPI: String) {
        self.urlSession = urlSession
        self.apiURL = testAPI
    }
    
    init(){
        self.urlSession = URLSession.shared
        self.apiURL = "https://api.exchangeratesapi.io/latest?access_key=\(apiKey)&format=1"
    }

    
    func fetchCurrentCurrencyConversion() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        guard let url = URL(string: apiURL) else {
            DispatchQueue.main.async {
                self.errorMessage = "URL is not valid"
            }
            return
        }
        
        guard Double(inputAmount) != nil else {
            DispatchQueue.main.async {
                self.errorMessage = "Input amount is not valid"
            }
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            guard let data, error == nil else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to receive data"
                }
                return
            }

            Task { @MainActor in
                do {
                    let responseData = try JSONDecoder().decode(ExchangeRate.self, from: data)
                    if responseData.success {
                        guard let rates = responseData.rates else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Rates of specific currency not found"
                            }
                            return
                        }

                        if self.base == "EUR" {
                            DispatchQueue.main.async {
                                self.conversionRate = rates[self.nextTarget]
                            }
                        } else if self.nextTarget == "EUR" {
                            if let baseRate = rates[self.base] {
                                DispatchQueue.main.async {
                                    self.conversionRate = 1 / baseRate
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.errorMessage = "Base currency not found"
                                }
                            }
                        } else {
                            if let baseRate = rates[self.base], let targetRate = rates[self.nextTarget] {
                                DispatchQueue.main.async {
                                    self.conversionRate = targetRate / baseRate
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.errorMessage = "Conversion rates for the currencies not found"
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.convertCurrency()
                            self.isLoading = false
                        }
                    } else if let errorDetails = responseData.error {
                        DispatchQueue.main.async {
                            self.errorMessage = "Error \(errorDetails.code): \(errorDetails.info)"
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to decode data"
                    }
                }
            }
        }.resume()
    }
    
    func convertCurrency() {
        if let inputAmountNumber = Double(self.inputAmount),
           let conversionRateNumber = self.conversionRate {
            let result = inputAmountNumber * conversionRateNumber
            DispatchQueue.main.async {
                self.convertedAmount = String(format: "%.2f", result)
            }
        } else {
            DispatchQueue.main.async {
                self.convertedAmount = ""
                self.errorMessage = "Invalid Input! Cannot convert currency"
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
