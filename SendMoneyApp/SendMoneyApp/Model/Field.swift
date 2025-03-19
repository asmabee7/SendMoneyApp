//
//  Field.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import Foundation

struct Field: Codable, Hashable {
    let label: LocalizedLabel?
    let name: String
    let placeholder: String?
    let validation: String?
    let maxLength: Int?
    let errorMessage: String?
    let type: FieldType?
    let options: [Option]?
    
    
    enum CodingKeys: String, CodingKey {
        case label, name, placeholder, validation
        case maxLength = "max_length"
        case errorMessage = "validation_error_message"
        case type, options
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try container.decodeIfPresent(LocalizedLabel.self, forKey: .label)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.placeholder = try container.decodeIfPresent(String.self, forKey: .placeholder)
        self.validation = try container.decodeIfPresent(String.self, forKey: .validation)
        self.maxLength = try container.decodeIfPresent(Int.self, forKey: .maxLength)
        self.errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
        let type = try container.decodeIfPresent(String.self, forKey: .type)
        self.type = FieldType(rawValue: type ?? "")
        self.options = try container.decodeIfPresent([Option].self, forKey: .options)
    }
}

enum FieldType: String, Codable {
    case number
    case option
    case text
    case msisdn
}

struct LocalizedLabel: Codable, Hashable {
    let en: String?
    let ar: String?
}

struct Option: Codable, Hashable {
    var label: String?
    var name: String?
}
