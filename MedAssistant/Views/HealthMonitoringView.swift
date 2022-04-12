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
    var symptoms: [String]
    var severity: [String] = []
    
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
                Text("Temperature")
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
                
                
                Text("Weight")
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
                    Text("Done")
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
        todayTemperature.value = Double(temperature) + Double(temperatureDecimal) * 0.1
        todayTemperature.date = Date.now
        todayTemperature.id = UUID()
        
        let todayWeight = Weight(context: moc)
        todayWeight.value = Double(weight) + Double(weightDecimal) * 0.1
        todayWeight.date = Date.now
        todayWeight.id = UUID()
        
        //can throw exception
        try? moc.save()
        
        
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct HealthMonitoringView_Previews: PreviewProvider {
    @State static var temperature: Int = 36
    @State static var temperatureDecimal: Int = 6
    @State static var weight: Int = 75
    @State static var weightDecimal: Int = 5
    
    static var previews: some View {
        HealthMonitoringView(temperature: $temperature, temperatureDecimal: $temperatureDecimal, weight: $weight, weightDecimal: $weightDecimal, symptoms: [], severity: [])
    }
}
