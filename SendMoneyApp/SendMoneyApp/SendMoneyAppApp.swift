//
//  SendMoneyAppApp.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import SwiftUI

@main
struct SendMoneyAppApp: App {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 105/255, green: 111/255, blue: 135/255, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some Scene {
        WindowGroup {
            LoginScreen()
            
        }
        .environmentObject(StoreManager())

    }
}
