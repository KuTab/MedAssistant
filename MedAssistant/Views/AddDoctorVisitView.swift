//
//  AddDoctorVisitView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 09.04.2022.
//

import SwiftUI

struct AddDoctorVisitView: View {
    @State var title: String = ""
    @State var date: Date = Date.now
    @FetchRequest(sortDescriptors: []) private var metaData: FetchedResults<DrugTakeMetaDataCD>
    @FetchRequest(sortDescriptors: []) private var doctorVisit: FetchedResults<DoctorVisitCD>
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            Text("Добавить посещение")
                .font(.title)
                .bold()
                .padding()
            
            Spacer()
            
            HStack {
                Text("Название посещения:")
                TextField("Введите название посещения", text: $title)
            }.padding()
                .textFieldStyle(.roundedBorder)
            
            DatePicker("Дата посещения", selection: $date)
                .padding()
            
            Spacer()
            
            Button (action: addVisit,
                    label: {
                Text("Добавить")
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.green, in: Capsule())
                    .foregroundColor(.white)
            }).padding()
        }.navigationBarTitle("", displayMode: .inline)
    }
    
    func addVisit() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notifications allowed")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        var calendar = Calendar.current
        
        let newDoctorVisit = DoctorVisitCD(context: moc)
        
        newDoctorVisit.id = UUID()
        newDoctorVisit.title = title
        newDoctorVisit.date = date
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = "Не забудте посетить врача"
        content.sound = UNNotificationSound.default
        
        let dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
        if let doctorVisitMD = metaData.first(where: { doctorVisit in
            return isSameDay(date1: doctorVisit.unwrappedDate, date2: date)
        }) {
            
            doctorVisitMD.addToDoctorVisitsCD(newDoctorVisit)
        } else {
            
            let newDrugTakeMd = DrugTakeMetaDataCD(context: moc)
            newDrugTakeMd.id = UUID()
            newDrugTakeMd.date = date //calendar.dateComponents([.day, .month, .year], from: drugTime).date
            newDrugTakeMd.addToDoctorVisitsCD(newDoctorVisit)
        }
        
        try? moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}

struct AddDoctorVisitView_Previews: PreviewProvider {
    static var previews: some View {
        AddDoctorVisitView()
    }
}
