//
//  LoginViewModel.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 29.01.2022.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    
    static let shared = LoginViewModel()
    
    // MARK: - Properties

    @Published var phone = ""
    @Published var password = ""
    @Published var isSigningIn = false
    @Published var isLoggedIn = UserDefaults.standard.object(forKey: "IsLoggedIn") as? Bool ?? false
    @Published var isRegistered = UserDefaults.standard.object(forKey: "IsRegistered") as? Bool ?? false
    @Published var name = ""
    @Published var surname = ""
    @Published var patronymic = ""
    @Published var preRegistered = false
    @Published var confirmationCode = ""
    
    //private var receivedCode = ""
    
    
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
        
        APIWorker.shared.registerRequest(username: name, surname: surname, patronymic: patronymic, phoneNumber: phone, password: password) { result in
            
            switch result {
            case .success(let code):
                print(code)
                //self.receivedCode = code
                
            case .failure(_):
                print("failure")
            }
        }
        
//        isRegistered = true
//        isLoggedIn = true
//        UserDefaults.standard.set(isLoggedIn, forKey: "IsLoggedIn")
        preRegistered = true
//        UserDefaults.standard.set(isRegistered, forKey: "IsRegistered")
//        UserDefaults.standard.set(name, forKey: "name")
//        UserDefaults.standard.set(surname, forKey: "surname")
    }
    
    //MARK: - Function for phoneConfirmation
    func confirm() {
        
        APIWorker.shared.confirmRequest(code: confirmationCode) { result in
            switch result {
            case .success(true):
                self.isRegistered = true
                self.isLoggedIn = true
                UserDefaults.standard.set(self.isLoggedIn, forKey: "IsLoggedIn")
                UserDefaults.standard.set(self.isRegistered, forKey: "IsRegistered")
                UserDefaults.standard.set(self.name, forKey: "name")
                UserDefaults.standard.set(self.surname, forKey: "surname")
            case .success(false):
                
                print("Wrong code")
            case .failure(_):
                
                print("failure")
            }
        }
    }
}
