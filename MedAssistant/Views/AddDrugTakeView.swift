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
    @State var daysOfTakes: String = "Каждый день"
    @State var daysSelected: [Bool] = [Bool](repeating: false, count: 7)
    
    //addition to a date for next drug take
    @State var daysAddition: Int = 1
    //options for days of take
    let optionValues = ["Каждый день", "Через день", "Выбранные дни"]
    let days = ["П", "В", "С", "Ч", "П", "С", "В"]
    
    @FetchRequest(sortDescriptors: []) private var drugTakeMD: FetchedResults<DrugTakeMetaDataCD>
    @FetchRequest(sortDescriptors: []) private var drugTake: FetchedResults<DrugTakeCD>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            
            Text("Добавить лекарство")
                .font(.title)
                .bold()
                .padding()
            
            ScrollView {
            HStack {
                Text("Название:")
                TextField("Введите название лекарства", text: $drugTitle)
            }.padding()
                .textFieldStyle(.roundedBorder)
            
            HStack {
                ForEach(days.indices, id: \.self) { index in
                    DayButton(isSelected: $daysSelected[index], dayName: days[index])
                        .frame(maxWidth: .infinity)
                }
            }.padding()
                .ignoresSafeArea(.keyboard)
            
            DatePicker("Начало приема", selection: $startDate, displayedComponents: .date)
                .padding()
            
            DatePicker("Окончание приема", selection: $endDate, displayedComponents: .date)
                .padding()
            
            HStack {
                Text("Количество приемов в день")
                Spacer()
                Picker("Количество приемов в день", selection: $numADay) {
                    ForEach(1..<4, id: \.self) { num in
                        Text("\(num)")
                            .foregroundColor(.black)//.white
                    }
                }
            }.padding()
            
            HStack {
                Text("Частота приема")
                Spacer()
                Picker("Частота приема", selection: $daysOfTakes) {
                    ForEach(optionValues, id: \.self) { option in
                        Text(option)
                            .foregroundColor(.black)
                    }
                }
            }.padding()
            
            ForEach(drugTime.indices, id: \.self) { index in
                DatePicker("Время приема №\(index + 1)", selection: $drugTime[index], displayedComponents: .hourAndMinute)
                    .padding()
                
            }
            
            Button (action: daysOfTakes == "Выбранные дни" ? addDrugByDaysSelected : addDrug,
                    label: {
                Text("Добавить")
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.green, in: Capsule())
                    .foregroundColor(.white)
            }).padding()
            }
            
            
            //MARK: - for development only
//            Button (action: removeAllData,
//                    label: {
//                Text("Clear Data")
//                    .fontWeight(.bold)
//                    .padding(.vertical)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.red, in: Capsule())
//                    .foregroundColor(.white)
//            }).padding()
//                .disabled(drugTime.isEmpty)
        }.navigationBarTitle("", displayMode: .inline)
            .onChange(of: numADay) { newValue in
                
                drugTime = [Date](repeating: Date.now, count: newValue)
            }
            .onChange(of: daysOfTakes) { newValue in
                switch newValue {
                case "Каждый день":
                    daysAddition = 1
                    
                case "Через день":
                    daysAddition = 2
                    
                case "Выбранные дни":
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
        
        APIWorker.shared.getUserID { result in
            switch result {
            case .success(let resultId) :
                APIWorker.shared.sendNewDrug(id: resultId, name: drugTitle, startDate: convertDate(date: startDate), endDate: convertDate(date: endDate), numDays: "5", type: "tablet", dosage: "100")
                print("Got an id and send request for adding drug")
            case .failure(_) :
                print()
                LoginViewModel.shared.isLoggedIn = false
                UserDefaults.standard.setValue(false, forKey: "IsLoggedIn")
                LoginViewModel.shared.error = "Ошибка соединения"

            }
        }
        
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
                content.subtitle = "Время принять лекарство"
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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications allowed")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let calendar = Calendar.current
        var totalDate = startDate
        let chosenDaysOfWeek = parseDayNumbers(chosenDays: daysSelected)
        print(chosenDaysOfWeek)
        
        APIWorker.shared.getUserID { result in
            switch result {
            case .success(let resultId) :
                APIWorker.shared.sendNewDrug(id: resultId, name: drugTitle, startDate: convertDate(date: startDate), endDate: convertDate(date: endDate), numDays: "2", type: "tablet", dosage: "100")
                print("Got an id and send request for adding drug")
            case .failure(_) :
                print()
                
                LoginViewModel.shared.isLoggedIn = false
                UserDefaults.standard.setValue(false, forKey: "IsLoggedIn")
                LoginViewModel.shared.error = "Ошибка соединения"

            }
        }
        
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
                    
                    let content = UNMutableNotificationContent()
                    content.title = drugTitle
                    content.subtitle = "Время принять лекарство"
                    content.sound = UNNotificationSound.default
                    
                    let dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: totalDate)
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request)
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
        
    func convertDate (date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

struct AddDrugTakeView_Previews: PreviewProvider {
    static var previews: some View {
        AddDrugTakeView()
    }
}
