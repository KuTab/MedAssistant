//
//  TemperatureView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 19.02.2022.
//

import Foundation
import SwiftUI

extension UIPickerView {
    open override var intrinsicContentSize: CGSize { return CGSize(width: UIView.noIntrinsicMetric , height: super.intrinsicContentSize.height)}
    
}

struct TemperatureView: View {
    @State private var temperature: Int = 36
    @State private var temperatureDecimal: Int = 6
    
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
                    
                //todo rework button style
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
        
        //can throw exception
        try? moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView()
    }
}
