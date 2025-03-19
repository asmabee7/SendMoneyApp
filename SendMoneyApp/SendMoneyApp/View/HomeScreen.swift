//
//  HomeScreen.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var store: StoreManager
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            SendMoneyScreen(store: store)
                .tabItem {
                    Label(Constants().sendMoney, systemImage: "dollarsign.circle")
                }
                .tag(0)
                
            
            SavedRequestsView()
                .tabItem {
                    Label(Constants().savedRequests, systemImage: "list.bullet")
                }
                .tag(1)
        }
        
        .navigationBarItems(trailing:
            Button(action: {
            store.dispatch(action: .switchLanguage(store.state.currentLanguage == .english ? .arabic : .english))
            UIView.appearance().semanticContentAttribute = store.state.currentLanguage == .arabic ? .forceRightToLeft : .forceLeftToRight
            }) {
                Text(store.state.currentLanguage == .english ? "Arabic" : "English")
            }
            .tint(.white)
        )
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(selectedTab == 0 ? Constants().sendMoney : Constants().savedRequests)
        .environment(\.layoutDirection, store.state.currentLanguage == .arabic ? .rightToLeft : .leftToRight)
        .environment(\.locale, Locale(identifier: store.state.currentLanguage == .arabic ? "ar" : "en"))

    }
}

