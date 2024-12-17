//
//  SwiftUIView.swift
//  Currency-Converter
//
//  Created by Minh Trương on 14/12/24.
//

import SwiftUI
import Combine

struct InputSection: View {
    var title: String
    @ObservedObject var viewModel: CurrentCurrencyConverterViewModel
    var isBase: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text(self.title)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack(spacing: 20){
                Menu {
                    ForEach(Country.countryData, id: \.self) { country in
                        Button(country.countryName, action: {
                            if isBase {
                                viewModel.base = country.countryCurrency
                                viewModel.baseCode = country.countryCode
                            } else {
                                viewModel.nextTarget = country.countryCurrency
                                viewModel.nextTargetCode = country.countryCode
                            }
                        })
                    }
                 } label: {
                     HStack (spacing: 5) {
                         Text(viewModel.emojiFlag(isBase ? viewModel.baseCode : viewModel.nextTargetCode))
                               .font(.system(size: 64))
                         Text(isBase ? viewModel.base : viewModel.nextTarget)
                             .cornerRadius(8)
                             .foregroundStyle(Color("darkblue"))
                             .fontWeight(.bold)
                             .font(.title3)

                         Image(systemName: "chevron.down") // Dropdown arrow
                             .foregroundStyle(Color("darkblue"))
                     }
                 }
                
                if(isBase){
                    TextField("Enter Amount", text: $viewModel.inputAmount)
                        .keyboardType(.decimalPad)
                        .padding(.all, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                        .cornerRadius(8)
                        .onReceive(Just(viewModel.inputAmount)) { newValue in
                          let allowedCharacters = "0123456789"
                          let filtered = newValue.filter { allowedCharacters.contains($0) }
                          if filtered != newValue {
                              viewModel.inputAmount = filtered
                          }
                      }
                }
                else{
                    TextField("Result amount", text: $viewModel.convertedAmount)
                        .padding(.all, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.trailing)
                        .cornerRadius(8)
                        .disabled(true)
                }

            }
        }
        .padding(.all , 12)
    }
}
