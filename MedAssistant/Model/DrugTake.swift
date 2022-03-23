//
//  DrugTake.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 24.03.2022.
//

import Foundation

//
struct DrugTake: Identifiable {
    var id = UUID().uuidString
    var title: String
    var time: Date = Date()
}

//total drug take meta view
struct DrugTakeMetaData: Identifiable {
    var id = UUID().uuidString
    var drugTakes: [DrugTake]
    var drugTakeDate: Date
}

//for testing
func getSampleData(offset: Int) -> Date {
    let calendar = Calendar.current
    
    let date = calendar.date(byAdding: .day, value: offset, to: Date())
    
    return date ?? Date()
}

//sample data
var drugTakes: [DrugTakeMetaData] = [
    DrugTakeMetaData(drugTakes: [DrugTake(title: "Drug 1"), DrugTake(title: "Drug 2")], drugTakeDate: getSampleData(offset: 1)),
    DrugTakeMetaData(drugTakes: [DrugTake(title: "Drug 3")], drugTakeDate: getSampleData(offset: -3))
]
