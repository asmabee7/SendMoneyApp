//
//  Untitled.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import Foundation

struct Service: Identifiable, Codable, Hashable {
    static func == (lhs: Service, rhs: Service) -> Bool {
        lhs.id == rhs.id
    }
    
    
    let id: Int?
    let label: LocalizedLabel?
    let name: String?
    let providers: [Provider]
}
