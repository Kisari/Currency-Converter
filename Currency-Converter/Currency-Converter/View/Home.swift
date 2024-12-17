//
//  ContentView.swift
//  Currency-Converter
//
//  Created by Minh Trương on 14/12/24.
//

import SwiftUI

struct Home: View {
    @StateObject var currencyViewModel: CurrentCurrencyConverterViewModel = CurrentCurrencyConverterViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Currency Converter")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(Color("darkblue"))
            
            Text("Check live rates, set rate alerts, receive notifications and more.")
                .font(.title3)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 16) {
                HStack {
                    InputSection(title: "Amount", viewModel: currencyViewModel, isBase: true)
                }

                if(currencyViewModel.isLoading){
                    ProgressView()
                }
                else{
                    Button(action: {    
                        currencyViewModel.fetchCurrentCurrencyConversion()
                    }) {
                        Text("Exchange")
                            .font(.title)
                            .padding(.all, 15)
                            .foregroundStyle(.white)
                            .background(Color("darkblue"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
    
                HStack {
                    InputSection(title: "Converted Amount", viewModel: currencyViewModel, isBase: false)
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
                .foregroundStyle(Color("darkblue"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            if(currencyViewModel.convertedAmount.isEmpty){
                Text("No current history")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            else{
                if let conversionRate = currencyViewModel.conversionRate {
                    Text("1 \(currencyViewModel.base) = \(String(format: "%.2f", conversionRate)) \(currencyViewModel.nextTarget)")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .alert("Error", isPresented: $currencyViewModel.showError, actions: {
            Button("OK", role: .cancel) {
                currencyViewModel.showError = false
                currencyViewModel.errorMessage = ""
            }
        }, message: {
            Text(currencyViewModel.errorMessage)
        })
    }
}

#Preview {
    Home()
}
