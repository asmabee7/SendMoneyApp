//
//  Constants.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import Foundation
import SwiftUI

class Constants {
    static var username = "testuser"
    static var password = "password123"
    static var appTitle = "SEND MONEY APP"
    static var appSubtitle = "Welcome to Send Money App!"
    static var signIn = "Sign In"
    static var emailPlaceholder = "Email*"
    static var passwordPlaceholder = "Password*"
    static var bottomMessage = "By proceeding you also agree to the Terms of service and Privacy policy"
    var sendMoney: String {
        return LocalizationManager.shared.localizedString(forKey: "send_money")
    }
    var savedRequests: String {
        return LocalizationManager.shared.localizedString(forKey: "saved_requests")
    }
    var send: String {
        return LocalizationManager.shared.localizedString(forKey: "send")
    }
    var details: String {
        return LocalizationManager.shared.localizedString(forKey: "details")
    }
    var service: String {
        return LocalizationManager.shared.localizedString(forKey: "service")
    }
    var provider: String {
        return LocalizationManager.shared.localizedString(forKey: "provider")
    }
    
}

