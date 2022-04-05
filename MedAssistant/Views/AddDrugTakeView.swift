//
//  AddDrugTakeView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 28.03.2022.
//

import SwiftUI
import UserNotifications

struct AddDrugTakeView: View {
    @State var drugTitle: String = ""
    @State var startDate: Date = Date.now
    @State var endDate: Date = Date.now
    @State var drugTime: [Date] = [Date.now]
    @State var numADay: Int = 1
    @State var daysOfTakes: String = "Everyday"
    @State var daysSelected: [Bool] = [Bool](repeating: false, count: 7)
    
    //addition to a date for next drug take
    @State var daysAddition: Int = 1
    //options for days of take
    let optionValues = ["Everyday", "In one day", "Select Days"]
    let days = ["M", "T", "W", "T", "F", "S", "S"]
    
    @FetchRequest(sortDescriptors: []) private var drugTakeMD: FetchedResults<DrugTakeMetaDataCD>
    @FetchRequest(sortDescriptors: []) private var drugTake: FetchedResults<DrugTakeCD>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HStack {
                Text("Title:")
                TextField("Enter drug title", text: $drugTitle)
            }.padding()
                .textFieldStyle(.roundedBorder)
            
            HStack {
                ForEach(days.indices, id: \.self) { index in
                    DayButton(isSelected: $daysSelected[index], dayName: days[index])
                        .frame(maxWidth: .infinity)
                }
            }.padding()
            
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
            
            Picker("Days of take", selection: $daysOfTakes) {
                ForEach(optionValues, id: \.self) { option in
                    Text(option)
                        .foregroundColor(.black)
                }
            }
            
            ForEach(drugTime.indices, id: \.self) { index in
                DatePicker("Time", selection: $drugTime[index], displayedComponents: .hourAndMinute)
                    .padding()
                
            }
            
            Button (action: daysOfTakes == "Select Days" ? addDrugByDaysSelected : addDrug,
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
            .onChange(of: daysOfTakes) { newValue in
                switch newValue {
                case "Everyday":
                    daysAddition = 1
                    
                case "In one day":
                    daysAddition = 2
                    
                case "Select days":
                    daysAddition = 1
                    
                default:
                    daysAddition = 1
                    
                }
            }
    }
    
    func addDrug() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications allowed")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        print("add drug")
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Europe/Moscow")!
        var totalDate = startDate
        
        //while loop for getting all dates in range of drug taking
        while totalDate <= endDate {
            
            //for loop for adding all drug takes a day
            for currentDrugTime in drugTime {
                //                print("save")
                
                let newDrugTake = DrugTakeCD(context: moc)
                
                newDrugTake.id = UUID()
                newDrugTake.title = drugTitle
                
                let parseTime = calendar.dateComponents([.timeZone, .minute, .hour], from: currentDrugTime)
                
                totalDate = calendar.date(bySetting: .hour, value: parseTime.hour!, of: totalDate)!
                totalDate = calendar.date(bySetting: .minute, value: parseTime.minute! , of: totalDate)!
                
                newDrugTake.time = totalDate
                
                let content = UNMutableNotificationContent()
                content.title = drugTitle
                content.subtitle = "It's time to take your medicine"
                content.sound = UNNotificationSound.default
                
                let dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: totalDate)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
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
            totalDate = calendar.date(byAdding: .day, value: daysAddition, to: totalDate)!
            totalDate = calendar.startOfDay(for: totalDate)
            print(totalDate)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func addDrugByDaysSelected() {
        let calendar = Calendar.current
        var totalDate = startDate
        let chosenDaysOfWeek = parseDayNumbers(chosenDays: daysSelected)
        print(chosenDaysOfWeek)
        
        while totalDate <= endDate {
            for chosenDayNumber in chosenDaysOfWeek {
                totalDate = calendar.date(bySetting: .weekday, value: chosenDayNumber, of: totalDate)!
                print(totalDate)
                
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
                    //                    print(parseTime)
                    //                    print(totalDate)
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
                
            }
            
            print(totalDate)
            //switch to the next week
            totalDate = calendar.nextDate(after: totalDate, matching: DateComponents(weekday: calendar.firstWeekday), matchingPolicy: .nextTime)!
            totalDate = calendar.startOfDay(for: totalDate)
            print(totalDate)
        }
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func parseDayNumbers(chosenDays: [Bool]) -> [Int] {
        var result: [Int] = []
        
        for index in chosenDays.indices {
            if chosenDays[index] {
                result.append(index + 2)
            }
        }
        
        if result.contains(8) {
            result.removeLast()
            result.insert(1, at: 0)
        }
        
        return result
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
