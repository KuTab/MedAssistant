//
//  DateValue.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 24.03.2022.
//

import Foundation

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
