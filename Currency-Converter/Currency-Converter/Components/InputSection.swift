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
    @State var viewModel: CurrentCurrencyConverterViewModel
    var isBase: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text(self.title)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack(spacing: 20){
                Menu {
                    
                 } label: {
                     HStack (spacing: 5) {
                         Text(viewModel.emojiFlag(isBase ? viewModel.base : viewModel.nextTarget))
                               .font(.system(size: 64))
                         Text(isBase ? viewModel.base : viewModel.nextTarget)
                             .cornerRadius(8)
                             .foregroundColor(.blue)
                             .fontWeight(.bold)
                             .font(.title3)

                         Image(systemName: "chevron.down") // Dropdown arrow
                             .foregroundColor(.blue)
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
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                viewModel.inputAmount = filtered
                            }
                        }
                }
                else{
                    TextField("Converted amount", text: $viewModel.convertedAmount)
                        .padding(.all, 12)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
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
