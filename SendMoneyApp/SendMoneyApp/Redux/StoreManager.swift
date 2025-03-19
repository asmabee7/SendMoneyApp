//
//  StoreManager.swift
//  SendMoneyApp
//
//  Created by Asma Bee on 18/03/2025.
//

import Foundation


class StoreManager: ObservableObject {
    @Published var state = AppState()
    
    func dispatch(action: AppAction) {
        state = appReducer(state: state, action: action)
    }
    
    func appReducer(state: AppState, action: AppAction) -> AppState {
        var newState = state
        switch action {
        case .login(let username, let password):
            if username == Constants.username && password == Constants.password {
                newState.isLoggedIn = true
                loadDataFromJSON(state: &newState)
            }
        case .saveRequest(let request):
            newState.savedRequests.append(request)
        case .loadServices(let services):
            newState.services = services
        case .switchLanguage(let language):
            newState.currentLanguage = language
//            let lang = language == .arabic ? "ar" : "en"
//            UserDefaults.standard.set([lang], forKey: "AppleLanguages")
//            UserDefaults.standard.synchronize()
            LocalizationManager.shared.setLanguage(language)
        }
        return newState
    }

    func loadDataFromJSON( state: inout AppState) {
        if let url = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(ParentData.self, from: data)
                state.services = decodedData.services
            } catch {
                print("Error loading JSON: \(error)")
            }
        } else {
            print("JSON file not found.")
        }
    }
}

struct AppState {
    var isLoggedIn: Bool = false
    var savedRequests: [SendMoneyRequest] = []
    var services: [Service] = []
    var currentLanguage: Language = .english
}

enum AppAction {
    case login(username: String, password: String)
    case saveRequest(SendMoneyRequest)
    case loadServices([Service])
    case switchLanguage(Language)
}

enum Language {
    case english
    case arabic
}
