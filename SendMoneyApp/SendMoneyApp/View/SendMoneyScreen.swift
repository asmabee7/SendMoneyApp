//
//  SendMoneyScreen.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import Foundation
import SwiftUI

struct SendMoneyScreen: View {
    @EnvironmentObject var store: StoreManager
    @State private var selectedService: Service?
    @State private var selectedProvider: Provider?
    @State private var fieldValues: [String: String] = [:]
    @State private var errors: [String: String] = [:]
    @State var didSend = false
    @Environment(\.layoutDirection) var layoutDirection
    
    var body: some View {
        NavigationView {
            Form {
                Picker(Constants().service, selection: $selectedService) {
                    Text("Select Service").tag(Service?.none)
                    ForEach(store.state.services) { service in
                        Text(localizedString(service.label))
                            .tag(Optional(service))
                    }
                }
                .pickerStyle(.menu)
                .flipsForRightToLeftLayoutDirection(false)
//                .flipsForRightToLeftLayoutDirection(true)
                
                if let service = selectedService {
                    Picker(Constants().provider, selection: $selectedProvider) {
                        Text("Select Provider").tag(Provider?.none)
                        ForEach(service.providers) { provider in
                            Text(provider.name ?? "")
                                .tag(Optional(provider))
                        }
                    }
//                    .flipsForRightToLeftLayoutDirection(true)
                }
                
                if let provider = selectedProvider {
                    ForEach(provider.required_fields, id: \.name) { field in
                        Section(header: Text(localizedString(field.label))) {
                            if let fieldType = field.type {
                                switch fieldType {
                                case .number, .text, .msisdn:
                                    TextField(field.placeholder ?? "", text: Binding(
                                        get: { fieldValues[field.name] ?? "" },
                                        set: { fieldValues[field.name] = $0 }
                                    ))
                                    .onChange(of: fieldValues[field.name], { oldValue, newvalue in
                                        if newvalue != nil {
                                            errors[field.name] = nil
                                        }
                                    })
                                    .keyboardType(field.type == .number ? .decimalPad : .default)
                                case .option:
                                    if let options = field.options {
                                        Picker(field.label?.en ?? "", selection: Binding(
                                            get: { fieldValues[field.name] ?? "" },
                                            set: { fieldValues[field.name] = $0 }
                                        )) {
                                            ForEach(options, id: \.self) { option in
                                                Text(option.label ?? "").tag(option.label ?? "")
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                    }
                                }
                                if let error = errors[field.name] {
                                    Text(error).foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Button(Constants().send) {
                            if validateFields() {
                                saveRequest()
                            }
                        }
                        Spacer()
                    }
                }
            }
                    
            .environment(\.layoutDirection, store.state.currentLanguage == .arabic ? .rightToLeft : .leftToRight)

            .onAppear {
                updateValues()
            }
            .alert("Info!", isPresented: $didSend, actions: {
                Button("OK", role: .cancel) { }
            }, message: {
                Text("Successfully sent money")
            })
            
            .navigationBarBackButtonHidden()
            .id(store.state.currentLanguage == .arabic) //  Forces view reload on language change
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func updateValues() {
        let service = store.state.services.first
        selectedService = service
        selectedProvider = service?.providers.first
    }
    
    private func validateFields() -> Bool {
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
    
    private func saveRequest() {
        didSend = true
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
    
    private func localizedString(_ label: LocalizedLabel?) -> String {
        store.state.currentLanguage == .english ? (label?.en ?? "") : (label?.ar ?? "")
    }

   
}


#Preview {
    SendMoneyScreen()
        .environmentObject(StoreManager())
}
