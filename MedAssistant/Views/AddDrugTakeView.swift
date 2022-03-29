//
//  AddDrugTakeView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 28.03.2022.
//

import SwiftUI

struct AddDrugTakeView: View {
    @State var drugTitle: String = ""
    @State var startDate: Date = Date.now
    @State var endDate: Date = Date.now
    @State var drugTime: [Date] = [Date.now]
    @State var numADay: Int = 1
    
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
            
            
            DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                .padding()
            
            DatePicker("End date", selection: $endDate, displayedComponents: .date)
                .padding()
            
            Picker("Takes a day", selection: $numADay) {
                ForEach(1..<4, id: \.self) { num in
                    Text("\(num)")
                        .foregroundColor(.black)//.white
                }
            }
            
            ForEach(drugTime.indices, id: \.self) { index in
                DatePicker("Time", selection: $drugTime[index], displayedComponents: .hourAndMinute)
                    .padding()
                
            }
            
            Button (action: addDrug,
                    label: {
                Text("Add")
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.green, in: Capsule())
                    .foregroundColor(.white)
            }).padding()
            
            //MARK: - for development only
            Button (action: removeAllData,
                    label: {
                Text("Clear Data")
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.red, in: Capsule())
                    .foregroundColor(.white)
            }).padding()
            
                .disabled(drugTime.isEmpty)
        }.navigationBarTitle("", displayMode: .inline)
            .onChange(of: numADay) { newValue in
                
                drugTime = [Date](repeating: Date.now, count: newValue)
            }
    }
    
    func addDrug() {
        let calendar = Calendar.current
        var totalDate = startDate
        
        //while loop for getting all dates in range of drug taking
        while totalDate <= endDate {
            
            //for loop for adding all drug takes a day
            for currentDrugTime in drugTime {
//                print("save")
                
                let newDrugTake = DrugTakeCD(context: moc)
                
                newDrugTake.id = UUID()
                newDrugTake.title = drugTitle
                
                let parseTime = calendar.dateComponents([.minute, .hour], from: currentDrugTime)
                
                totalDate = calendar.date(bySetting: .hour, value: parseTime.hour!, of: totalDate)!
                totalDate = calendar.date(bySetting: .minute, value: parseTime.minute! , of: totalDate)!
                
                newDrugTake.time = totalDate
//                print(startDate)
                print(parseTime)
                print(totalDate)
//                print(currentDrugTime)
                
                if let drugTakeMD = drugTakeMD.first(where: { drugTake in
                    return isSameDay(date1: drugTake.unwrappedDate, date2: totalDate)
                }) {
                    
                    drugTakeMD.addToDrugTakesCD(newDrugTake)
//                    print(drugTakeMD.drugTakesArray)
                } else {
                    
                    let newDrugTakeMd = DrugTakeMetaDataCD(context: moc)
                    newDrugTakeMd.id = UUID()
                    newDrugTakeMd.date = totalDate //calendar.dateComponents([.day, .month, .year], from: drugTime).date
                    newDrugTakeMd.addToDrugTakesCD(newDrugTake)
                }
                
                try? moc.save()
            }
            
            //increasing date
            totalDate = calendar.date(byAdding: .day, value: 1, to: totalDate)!
            totalDate = calendar.startOfDay(for: totalDate)
            print(totalDate)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    //MARK: - for development only
    private func removeAllData() {
        for tempDrugTakeMD in drugTakeMD {
            moc.delete(tempDrugTakeMD)
            try? moc.save()
        }
        
        for tempDrugTake in drugTakeMD {
            moc.delete(tempDrugTake)
            try? moc.save()
        }
    }
}

struct AddDrugTakeView_Previews: PreviewProvider {
    static var previews: some View {
        AddDrugTakeView()
    }
}
