//
//  AddDrugTakeView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 28.03.2022.
//

import SwiftUI

struct AddDrugTakeView: View {
    @State var drugTitle: String = ""
    @State var drugTime: Date = Date.now
    
    @FetchRequest(sortDescriptors: []) private var drugTakeMD: FetchedResults<DrugTakeMetaDataCD>
    @FetchRequest(sortDescriptors: []) private var drugTake: FetchedResults<DrugTakeCD>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HStack{
                Text("Title:")
                TextField("Enter drug title", text: $drugTitle)
            }.padding()
                .textFieldStyle(.roundedBorder)
            
            DatePicker("Date", selection: $drugTime)
                .padding()
            
            Button (action: addDrug,
                    label: {
                Text("Add")
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.green, in: Capsule())
                    .foregroundColor(.white)
            }).padding()
        }.navigationBarTitle("", displayMode: .inline)
    }
    
    func addDrug() {
        let newDrugTake = DrugTakeCD(context: moc)
        newDrugTake.id = UUID()
        newDrugTake.title = drugTitle
        newDrugTake.time = drugTime
        
        if let drugTakeMD = drugTakeMD.first(where: { drugTake in
            return isSameDay(date1: drugTake.unwrappedDate, date2: drugTime)
        }) {
           
            drugTakeMD.addToDrugTakesCD(newDrugTake)
            print(drugTakeMD.drugTakesArray)
        } else {
            
            let newDrugTakeMd = DrugTakeMetaDataCD(context: moc)
            let calendar = Calendar.current
            newDrugTakeMd.id = UUID()
            newDrugTakeMd.date = drugTime //calendar.dateComponents([.day, .month, .year], from: drugTime).date
            newDrugTakeMd.addToDrugTakesCD(newDrugTake)
        }
        
        try? moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct AddDrugTakeView_Previews: PreviewProvider {
    static var previews: some View {
        AddDrugTakeView()
    }
}
