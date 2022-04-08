//
//  BotResponse.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 11.01.2022.
//

import Foundation

let qAndAlist : [[String] : String] = [["что", "такое", "туберкулёз"] : "Туберкулёз - это инфекционное заболевание, вызываемое микобактериями туберкулеза, которые часто называют палочками Коха. Заболевание развивается только в ответ на размножение в организме человека этих микробов. Самой распространенной формой туберкулёза является туберкулёз лёгких." , ["как", "передаётся", "туберкулёз"] : "Туберкулез распространяется от человека человеку при контакте с больным туберкулезом:при кашле, чихании, соприкосновении с другим материалом, содержащим микобактерии."]

func getBotResponse(message: String) -> String {
    let tempMessage = message.lowercased()
    
//    if tempMessage.contains("hello") {
//        return "Hey there!"
//    } else if tempMessage.contains("goodbye") {
//        return "Talk to you later!"
//    } else {
//        return "Default"
//    }
    
    let result =  qAndAlist.first(where: { $0.key.allSatisfy(tempMessage.contains) })?.value
    if let result = result {
        return result
    } else {
        return "К сожалению, я не могу ответить на данный вопрос."
    }
}
