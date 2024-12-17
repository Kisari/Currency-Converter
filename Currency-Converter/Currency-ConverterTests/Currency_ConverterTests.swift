//
//  Currency_ConverterTests.swift
//  Currency-ConverterTests
//
//  Created by Minh Trương on 14/12/24.
//

import Testing
@testable import Currency_Converter

struct Currency_ConverterTests {

    @Test("Test should throw an error for invalid input")
    func testInputValidation() async throws {
        MockURLProtocol.reset()
        let viewModel = await MainActor.run { CurrentCurrencyConverterViewModel(urlSession: setupMockURLSession(), testAPI: "https://api.exchangeratesapi.io/latest") }
        await MainActor.run {
            viewModel.inputAmount = ""
        }
        
        await viewModel.fetchCurrentCurrencyConversion()
        
        try await Task.sleep(nanoseconds: 500_000_000) // Allow async code to execute
        
        await MainActor.run {
            #expect(viewModel.errorMessage == "Input amount is not valid")
            #expect(viewModel.showError == true, "showError should be true when there is an error")
        }
    }
    
    @Test("Test should throw no error at the function conversion currency")
    func testSuccessfulConversion() async throws {
        MockURLProtocol.reset()
        // Mock a successful API response
        let mockRates: [String: Double] = ["USD": 1.0, "VND": 23000.0]
        let mockExchangeRate = ExchangeRate(success: true, error: nil, rates: mockRates)
        
        let viewModel = await MainActor.run { CurrentCurrencyConverterViewModel(urlSession: setupMockURLSession(), testAPI: "https://api.exchangeratesapi.io/latest") }
        await MainActor.run {
            viewModel.inputAmount = "100"
            viewModel.base = "USD"
            viewModel.nextTarget = "VND"
        }
        
        // Mock API Call
        MockURLProtocol.reset()
        MockURLProtocol.mockResponse(with: mockExchangeRate)
        await viewModel.fetchCurrentCurrencyConversion()
        
        try await Task.sleep(nanoseconds: 5_000_000_000)
        
        await MainActor.run {
            #expect(viewModel.conversionRate == 23000.0)
            #expect(viewModel.convertedAmount == "2300000.00")
        }
    }
    
    @Test("Test should throw an error when there is no API access key")
    func testErrorInResponse() async throws {
        MockURLProtocol.reset()
        // Mock an API response with an error
        let mockError = ErrorDetails(code: 101, type: "missing_access_key",info: "You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]")
        let mockExchangeRate = ExchangeRate(success: false, error: mockError, rates: nil)
        
        let viewModel = await MainActor.run { CurrentCurrencyConverterViewModel(urlSession: setupMockURLSession(), testAPI: "https://api.exchangeratesapi.io/latest") }
        
        await MainActor.run {
            viewModel.inputAmount = "100"
        }
        
        // Mock the API response
        MockURLProtocol.mockResponse(with: mockExchangeRate)
        await viewModel.fetchCurrentCurrencyConversion()
        
        try await Task.sleep(nanoseconds: 5_000_000_000)
        
        await MainActor.run {
            #expect(viewModel.errorMessage == "Error 101: You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]")
            #expect(viewModel.showError == true)
        }
    }

}
