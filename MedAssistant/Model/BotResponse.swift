//
//  BotResponse.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 11.01.2022.
//

import Foundation

func getBotResponse(message: String) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("hello") {
        return "Hey there!"
    } else if tempMessage.contains("goodbye") {
        return "Talk to you later!"
    } else {
        return "Default"
    }
}
