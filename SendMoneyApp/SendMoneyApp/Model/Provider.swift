//
//  Provider.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import Foundation

struct Provider: Identifiable, Codable, Hashable {
    static func == (lhs: Provider, rhs: Provider) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String?
    let name: String?
    let required_fields: [Field]
}
