//
//  HealthMonitoringView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 11.04.2022.
//

import SwiftUI

extension UIPickerView {
    open override var intrinsicContentSize: CGSize { return CGSize(width: UIView.noIntrinsicMetric , height: super.intrinsicContentSize.height)}
    
}

struct HealthMonitoringView: View {
    @Binding var temperature: Int
    @Binding var temperatureDecimal: Int
    @Binding var weight: Int
    @Binding var weightDecimal: Int
    //var symptoms: [String]
    //var severity: [String] = []
    var symptomsBody: [[String : String]]
    
    //all Health records about weight
    @FetchRequest(sortDescriptors: []) private var weightData: FetchedResults<Weight>
    
    //all Health records about temperature
    @FetchRequest(sortDescriptors: []) private var temperatureData: FetchedResults<Temperature>
    @Environment(\.managedObjectContext) var moc
    
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            //ZStack {
            //LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
            VStack() {
                Text("Температура")
                    .foregroundColor(.blue)//.white
                    .font(.system(size: 60))
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Picker("", selection: $temperature) {
                        ForEach(34..<43, id: \.self) { num in
                            Text("\(num).")
                                .foregroundColor(.black)//.white
                        }
                    }.pickerStyle(.wheel)
                        .frame(width: geometry.size.width/3, height: 100)
                        .compositingGroup()
                        .clipped()
                        .padding(.horizontal)
                    
                    Picker("", selection: $temperatureDecimal) {
                        ForEach(0..<10, id: \.self) { num in
                            Text("\(num)")
                                .foregroundColor(.black)//.white
                        }
                    }.pickerStyle(.wheel)
                        .frame(width: geometry.size.width/3, height: 100)
                        .compositingGroup()
                        .clipped()
                        .padding(.horizontal)
                }.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 4))//.white
                
                Spacer()
                
                
                Text("Вес")
                    .foregroundColor(.blue)//.white
                    .font(.system(size: 60))
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                
                Spacer()
                
                HStack(spacing: 0) {
                    
                    Picker("", selection: $weight) {
                        ForEach(0..<150, id: \.self) { num in
                            Text("\(num).")
                                .foregroundColor(.black)//.white
                        }
                    }.pickerStyle(.wheel)
                        .frame(width: geometry.size.width/3, height: 100)
                        .compositingGroup()
                        .clipped()
                        .padding(.horizontal)
                    
                    Picker("", selection: $weightDecimal) {
                        ForEach(0..<10, id: \.self) { num in
                            Text("\(num)")
                                .foregroundColor(.black)//.white
                        }
                    }.pickerStyle(.wheel)
                        .frame(width: geometry.size.width/3, height: 100)
                        .compositingGroup()
                        .clipped()
                        .padding(.horizontal)
                }.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 4))//.white
                
                Spacer()
                
                Button(action: doneMonitoring,
                       label: {
                    Text("Завершить")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.black)//.white
                        .padding()
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth:  4))//.white
                    
                    
                })
            }.navigationBarTitle("", displayMode: .inline)
            
            //}.navigationBarTitle("", displayMode: .inline) ZStack
        }
        
        
    }
    
    func doneMonitoring() {
        let todayTemperature = Temperature(context: moc)
        let finalTemperature = Double(temperature) + Double(temperatureDecimal) * 0.1
        todayTemperature.value = finalTemperature
        todayTemperature.date = Date.now
        todayTemperature.id = UUID()
        
        let todayWeight = Weight(context: moc)
        let finalWeight = Double(weight) + Double(weightDecimal) * 0.1
        todayWeight.value = finalWeight
        todayWeight.date = Date.now
        todayWeight.id = UUID()
        
        //can throw exception
        try? moc.save()
        
        APIWorker.shared.getUserID() { respone in
            switch respone {
            case .success(let id):
                APIWorker.shared.sendHealthInfo(id: id, temperature: String(finalTemperature), weight: String(finalWeight), symptomsBody: symptomsBody)
            case .failure(_):
                print("failure")
                LoginViewModel.shared.isLoggedIn = false
                UserDefaults.standard.setValue(false, forKey: "IsLoggedIn")
                LoginViewModel.shared.error = "Ошибка соединения"
            }
        }
        print(Date.now)
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct HealthMonitoringView_Previews: PreviewProvider {
    @State static var temperature: Int = 36
    @State static var temperatureDecimal: Int = 6
    @State static var weight: Int = 75
    @State static var weightDecimal: Int = 5
    
    static var previews: some View {
        HealthMonitoringView(temperature: $temperature, temperatureDecimal: $temperatureDecimal, weight: $weight, weightDecimal: $weightDecimal, symptomsBody: [])
    }
}
