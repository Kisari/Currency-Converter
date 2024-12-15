//
//  SwiftUIView.swift
//  Currency-Converter
//
//  Created by Minh Trương on 14/12/24.
//

import SwiftUI
import Combine

struct SwiftUIView: View {
    var title: String
    @State private var test: String = ""
    @State private var country: Country?
    @State private var selectedCurrency: String = "SGD"
    
    var body: some View {
        VStack(alignment: .leading){
            Text(self.title)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack(spacing: 20){
                Menu {
                    
                 } label: {
                     Text(selectedCurrency)
                         .frame(width: 100)
                         .padding()
                         .cornerRadius(8)
                         .foregroundColor(.blue)
                         .fontWeight(.bold)
                 }
                TextField("Enter Amount", text: $test)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: .infinity)
                    .onReceive(Just(test)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.test = filtered
                        }
                    }
            }
        }
    }
}

#Preview {
    SwiftUIView(title: "Ammount Converted")
}
