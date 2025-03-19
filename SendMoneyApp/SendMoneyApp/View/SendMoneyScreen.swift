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
    @State var didSend = false
    @Environment(\.layoutDirection) var layoutDirection
    
    @StateObject private var viewModel: SendMoneyViewModel
    
    init(store: StoreManager) {
            _viewModel = StateObject(wrappedValue: SendMoneyViewModel(store: store))
        }
    
    var body: some View {
        NavigationView {
            Form {
                Picker(Constants().service, selection: $viewModel.selectedService) {
                    Text("Select Service").tag(Service?.none)
                    ForEach(store.state.services) { service in
                        Text(viewModel.localizedString(service.label))
                            .tag(Optional(service))
                    }
                }
                .pickerStyle(.menu)
                .flipsForRightToLeftLayoutDirection(false)
                
                if let service = viewModel.selectedService {
                    Picker(Constants().provider, selection: $viewModel.selectedProvider) {
                        Text("Select Provider").tag(Provider?.none)
                        ForEach(service.providers) { provider in
                            Text(provider.name ?? "")
                                .tag(Optional(provider))
                        }
                    }
                }
                
                if let provider = viewModel.selectedProvider {
                    ForEach(provider.required_fields, id: \.name) { field in
                        Section(header: Text(viewModel.localizedString(field.label))) {
                            if let fieldType = field.type {
                                switch fieldType {
                                case .number, .text, .msisdn:
                                    TextField(field.placeholder ?? "", text: Binding(
                                        get: { viewModel.fieldValues[field.name] ?? "" },
                                        set: { viewModel.fieldValues[field.name] = $0 }
                                    ))
                                    .onChange(of: viewModel.fieldValues[field.name], { oldValue, newvalue in
                                        if newvalue != nil {
                                            viewModel.errors[field.name] = nil
                                        }
                                    })
                                    .keyboardType(field.type == .number ? .decimalPad : .default)
                                case .option:
                                    if let options = field.options {
                                        Picker(field.label?.en ?? "", selection: Binding(
                                            get: { viewModel.fieldValues[field.name] ?? "" },
                                            set: { viewModel.fieldValues[field.name] = $0 }
                                        )) {
                                            ForEach(options, id: \.self) { option in
                                                Text(option.label ?? "").tag(option.label ?? "")
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                    }
                                }
                                if let error = viewModel.errors[field.name] {
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
                            didSend = true
                            if viewModel.validateFields() {
                                viewModel.saveRequest()
                            }
                        }
                        Spacer()
                    }
                }
            }
                    
            .environment(\.layoutDirection, store.state.currentLanguage == .arabic ? .rightToLeft : .leftToRight)

            .onAppear {
                viewModel.updateValues()
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
}
