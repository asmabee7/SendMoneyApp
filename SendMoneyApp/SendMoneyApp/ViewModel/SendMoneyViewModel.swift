//
//  SendMoneyViewModel.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 20/03/2025.
//

import Foundation
import SwiftUI

class SendMoneyViewModel: ObservableObject {
    @Published var selectedService: Service?
    @Published var selectedProvider: Provider?
    @Published var fieldValues: [String: String] = [:]
    @Published var errors: [String: String] = [:]
    
    private let services: [Service]
    private let store: StoreManager
    
    init(store: StoreManager) {
        self.store = store
        self.services = store.state.services
    }
    
    var availableServices: [Service] {
        return services
    }
    
    var availableProviders: [Provider] {
        return selectedService?.providers ?? []
    }
    
    func updateFieldValue(_ value: String, forFieldName fieldName: String) {
        fieldValues[fieldName] = value
    }
    
     func validateFields() -> Bool {
        guard let provider = selectedProvider else { return false }
        errors.removeAll()
        
        for field in provider.required_fields {
            let value = fieldValues[field.name] ?? ""
            if let validation = field.validation {
                if validation == "" && value.isEmpty {
                    errors[field.name] = field.errorMessage //localizedString(field.errorMessage)
                } else if let regex = try? NSRegularExpression(pattern: validation),
                          regex.firstMatch(in: value, range: NSRange(value.startIndex..., in: value)) == nil {
                    errors[field.name] = field.errorMessage //localizedString(field.errorMessage)
                }
            }
            if let maxLength = field.maxLength , maxLength != 0 {
                if value.count > maxLength {
                    errors[field.name] = field.errorMessage

                }
            }
        }
        return errors.isEmpty
    }
    
    func saveRequest() {
        guard let service = selectedService,
              let provider = selectedProvider,
              let amountStr = fieldValues["amount"],
              let amount = Double(amountStr) else { return }
        
        let request = SendMoneyRequest(
            serviceName: localizedString(service.label),
            providerName: provider.name ?? "",
            amount: amount,
            details: fieldValues
        )
        store.dispatch(action: .saveRequest(request))
        fieldValues.removeAll()
        updateValues()
    }
    
    func updateValues() {
        let service = store.state.services.first
        selectedService = service
        selectedProvider = service?.providers.first
    }
    
    func localizedString(_ label: LocalizedLabel?) -> String {
        store.state.currentLanguage == .english ? (label?.en ?? "") : (label?.ar ?? "")
    }
}
