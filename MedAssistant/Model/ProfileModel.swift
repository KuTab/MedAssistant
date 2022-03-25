//
//  ProfileModel.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 25.03.2022.
//

import Foundation

class ProfileModel: ObservableObject {
    static let shared = ProfileModel()
    private let defaults = UserDefaults.standard
    
    @Published var name: String
    @Published var surname: String
    @Published var age: String
    
    init() {
        name = defaults.object(forKey: "name") as? String ?? ""
        surname = defaults.object(forKey: "surname") as? String ?? ""
        //todo think about making age Int type
        age = defaults.object(forKey: "age") as? String ?? ""
    }
    
    func save() {
        defaults.set(name, forKey: "name")
        defaults.set(surname, forKey: "surname")
        defaults.set(age, forKey: "age")
    }
}
