//
//  LocalizationManager.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 19/03/2025.
//

import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()
    
    private var currentLanguage: String
    private var bundle: Bundle?
    
    private init() {
        let deviceLanguage = Locale.preferredLanguages.first?.prefix(2).description ?? "en"
        self.currentLanguage = deviceLanguage
        updateBundle()
    }
    
    func setLanguage(_ language: Language) {
        self.currentLanguage = language == .english ? "en" : "ar"
        updateBundle()
        NotificationCenter.default.post(name: NSLocale.currentLocaleDidChangeNotification, object: nil)
    }
    
    func getCurrentLanguage() -> Language {
        return currentLanguage == "en" ? .english : .arabic
    }
    
    func localizedString(forKey key: String, comment: String = "") -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
    
    private func updateBundle() {
        guard let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            self.bundle = Bundle.main
            return
        }
        self.bundle = bundle
    }
}
