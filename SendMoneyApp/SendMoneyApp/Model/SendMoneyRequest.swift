//
//  SendMoneyRequest.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import Foundation


struct SendMoneyRequest: Identifiable {
    let id = UUID()
    let serviceName: String
    let providerName: String
    let amount: Double
    let details: [String: Any]
}


