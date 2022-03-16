//
//  LoginViewModel.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 29.01.2022.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    // MARK: - Properties

    @Published var email = ""
    @Published var password = ""
    @Published var isSigningIn = false
    @Published var isLoggedIn = UserDefaults.standard.object(forKey: "IsLoggedIn") as? Bool ?? false
    
    
    var canSignIn: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - Function performing authorization
    func signIn() {
        guard canSignIn else {
            return
        }
        
        isLoggedIn = true
        UserDefaults.standard.set(isLoggedIn, forKey: "IsLoggedIn")
    }
}
