//
//  SavedRequestsView.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import SwiftUI

struct SavedRequestsView: View {
    @EnvironmentObject var store: StoreManager
        @State private var showingDetails: SendMoneyRequest?
        
        var body: some View {
            NavigationView {
                List(store.state.savedRequests) { request in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(request.serviceName)
                            Text(request.providerName)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(String(format: "%.2f AED", request.amount))
                        Button(Constants().details) {
                            showingDetails = request
                        }
                    }
                }
//                .navigationTitle(localizedString(["en": "Saved Requests", "ar": "الطلبات المحفوظة"]))
                .sheet(item: $showingDetails) { request in
                    RequestDetailView(request: request)
                }
                .navigationBarBackButtonHidden()
                .navigationBarTitleDisplayMode(.inline)
                .id(store.state.currentLanguage == .arabic)
            }
        }
        
        private func localizedString(_ dict: [String: String]) -> String {
            dict[store.state.currentLanguage == .english ? "en" : "ar"] ?? dict["en"] ?? ""
        }
}
