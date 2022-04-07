//
//  CurrentUserModel.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 07.04.2022.
//

import Foundation

class CurrentUserModel: Codable {
    var id: Int
    var phoneNumber : String
    var firstName : String
    var lastName: String
    var patronymic : String
    var age : Int?
    var height : Int?
    var education : String?
    var workExperience : String?
    var specialization : String?
    var role : String
    var locked : Bool
    var enabled : Bool
}
