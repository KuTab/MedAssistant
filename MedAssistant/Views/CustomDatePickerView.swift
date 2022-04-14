//
//  CustomDatePickerView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 24.03.2022.
//

import SwiftUI

struct CustomDatePickerView: View {
    @Binding var currentDate: Date
    
    //all Health records about drugTakeMetaData
    @FetchRequest(sortDescriptors: []) private var drugTakeMD: FetchedResults<DrugTakeMetaDataCD>
    @Environment(\.managedObjectContext) var moc
    
    //Month update on arrow button
    @State var currentMonth: Int = 0
    
    var body: some View {
        
        VStack(spacing: 35) {
            
            //Days
            let days: [String] = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
            
            HStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text(getDate()[0])
                        .font(.caption)
                        .fontWeight(.semibold)
                    
                    Text(getDate()[1])
                        .font(.title.bold())
                }
                
                Spacer(minLength: 0)
                
                Button {
                    withAnimation {
                        currentMonth -= 1
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(Color.blue)
                }
                
                Button {
                    withAnimation {
                        currentMonth += 1
                    }
                    
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .foregroundColor(Color.blue)
                }
            }
            .padding(.horizontal)
            
            //DayView
            HStack(spacing: 0) {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.callout)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }
            
            //Dates
            let columns = Array(repeating: GridItem(.flexible()), count: 7)
            
            LazyVGrid(columns: columns, spacing: 15) {
                
                ForEach(extractDate()) { value in
                    
                    CardView(value: value)
                        .background(
                            Capsule()
                                .fill(Color.pink)
                                .padding(.horizontal, 8)
                                .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0)
                        ).onTapGesture {
                            currentDate = value.date
                        }
                }
            }
            
            VStack(spacing: 30) {
                
                Text("События")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 20)
                
                if let drugTake = drugTakeMD.first(where: { drugTake in
                    return isSameDay(date1: drugTake.unwrappedDate, date2: currentDate)
                }){
                    Text("Приемы лекарств")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if(!drugTake.drugTakesArray.isEmpty) {
                        ForEach(drugTake.drugTakesArray) { drugTake in
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(drugTake.unwrappedTime, style: .time)
                                
                                Text(drugTake.unwrappedTiltle)
                                    .font(.title2.bold())
                            }.padding(.vertical, 10)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.purple.opacity(0.5).cornerRadius(10))
                        }
                    } else {
                        Text("Не запланированы приемы лекарств")
                    }
                    
                    
                    Text("Посещения врача")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if(!drugTake.doctorVisitsArray.isEmpty){
                        ForEach(drugTake.doctorVisitsArray) { doctorVisit in
                            
                            VStack(alignment: .leading, spacing: 10) {
                                
                                Text(doctorVisit.unwrappedDate, style: .time)
                                
                                Text(doctorVisit.unwrappedTiltle)
                                    .font(.title2.bold())
                            }.padding(.vertical, 10)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.orange.opacity(0.5).cornerRadius(10))
                        }
                    } else {
                        Text("Не запланированы посещения врача")
                    }
                    
                } else {
                    
                    Text("Нет событий на этот день")
                }
            }.padding()
        }
        .onChange(of: currentMonth) { newValue in
            
            //updating month
            currentDate = getCurrentMonth()
        }
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        
        VStack {
            
            if value.day != -1 {
                if let drugTake = drugTakeMD.first(where: { drugTake in
                    
                    return isSameDay(date1: drugTake.unwrappedDate, date2: value.date)
                }){
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: drugTake.unwrappedDate, date2: currentDate) ? Color.white : Color.primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    Circle()
                        .fill(isSameDay(date1: drugTake.unwrappedDate, date2: currentDate) ? Color.white : Color.pink)
                        .frame(width: 8, height: 8)
                } else {
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .foregroundColor(isSameDay(date1: value.date, date2: currentDate) ? Color.white : Color.primary)
                        .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                }
            }
        }.padding(.vertical, 9)
            .frame(height: 60, alignment: .top)
    }
    
    //checking dates
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    //extracting year and month for display
    func getDate() -> [String] {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "YYYY LLLL"
        
        let date = formatter.string(from: currentDate).capitalized
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        
        let calendar = Calendar.current
        
        //Getting current month date
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date())
        else {
            return Date()
        }
        
        return currentMonth
    }
    
    func extractDate() -> [DateValue] {
        
        let calendar = Calendar.current
        
        //Getting current month date
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValue in
            
            //getting day
            let day = calendar.component(.day, from: date)
            
            return DateValue(day: day, date: date)
        }
        
        //print(days)
        
        //adding offset days to get exact week day
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        print(firstWeekDay)
        
        if firstWeekDay != 1 {
            for _ in 0..<firstWeekDay-2 {
                days.insert(DateValue(day: -1, date: Date()), at: 0)
            }
        } else {
            for _ in 0..<6 {
                days.insert(DateValue(day: -1, date: Date()), at: 0)
            }
        }
        
        return days
    }
}

struct CustomDatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

//Extending Date to get Current Month dates
extension Date {
    
    func getAllDates() -> [Date] {
        
        let calendar = Calendar.current
        
        //getting start date
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        //getting date
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
