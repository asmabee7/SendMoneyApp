//
//  RequestDetailView.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import SwiftUI

struct RequestDetailView: View {
    let request: SendMoneyRequest
        
        var body: some View {
            ScrollView {
                if let jsonData = try? JSONSerialization.data(withJSONObject: request.details),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    Text(jsonString)
                        .padding()
                }
            }
            .navigationTitle("Request Details")
        }
}

