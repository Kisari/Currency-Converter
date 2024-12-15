//
//  ContentView.swift
//  Currency-Converter
//
//  Created by Minh Trương on 14/12/24.
//

import SwiftUI

struct Home: View {
    @State private var api: CurrentCurrencyConverterViewModel = .init()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Currency Converter")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Check live rates, set rate alerts, receive notifications and more.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                HStack {
                    InputSection(title: "Amount", viewModel: api, isBase: true)
                }

                Button(action: {
//                    let temp = viewModel.baseCurrency
//                    viewModel.baseCurrency = viewModel.targetCurrency
//                    viewModel.targetCurrency = temp
//                    viewModel.fetchExchangeRate()
                }) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.largeTitle)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .clipShape(Circle())
                        .rotationEffect(.degrees(90))
                }
                
                HStack {
                    InputSection(title: "Converted Amount", viewModel: api, isBase: false)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(radius: 4)
            .padding()
            
            Text("Current Exchange Rate")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if let conversionRate = api.conversionRate {
                Text("1 \(api.base) = \(String(format: "%.2f", conversionRate)) \(api.nextTarget)")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }


            
            Spacer()
        }
    }
}

#Preview {
    Home()
}
