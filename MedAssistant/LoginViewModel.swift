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

    @Published var phone = ""
    @Published var password = ""
    @Published var isSigningIn = false
    @Published var isLoggedIn = UserDefaults.standard.object(forKey: "IsLoggedIn") as? Bool ?? false
    @Published var isRegistered = UserDefaults.standard.object(forKey: "IsRegistered") as? Bool ?? false
    @Published var name = ""
    @Published var surname = ""
    @Published var patronymic = ""
    
    
    var canSignIn: Bool {
        !phone.isEmpty && !password.isEmpty
    }
    
    // MARK: - Function performing authorization
    func signIn() {
        guard canSignIn else {
            return
        }
    
        APIWorker.shared.loginRequest(username: phone, password: password) { result in
            switch result {
            case .success(true):
                print("Successful authorization")
                self.isLoggedIn = true
                UserDefaults.standard.set(self.isLoggedIn, forKey: "IsLoggedIn")
                
            case .success(false):
                print("error in loggining")
                
            case .failure(_):
                print("failure")
            }
        }
    }
    
    // MARK: - Function performing registration
    func register() {
        guard canSignIn else {
            return
        }
        
        isRegistered = true
        isLoggedIn = true
        UserDefaults.standard.set(isLoggedIn, forKey: "IsLoggedIn")
        UserDefaults.standard.set(isRegistered, forKey: "IsRegistered")
        UserDefaults.standard.set(name, forKey: "name")
        UserDefaults.standard.set(surname, forKey: "surname")
    }
}
