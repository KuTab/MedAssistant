//
//  Symptom.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 09.04.2022.
//

import Foundation

struct Symptom: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var description: String
}

struct Symptoms: Codable {
    var symptoms: [Symptom]
}
