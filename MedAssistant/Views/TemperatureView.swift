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
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
                VStack {
                    Text("Temperature")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .bold()
                    
                    Spacer()
                    
                    HStack(spacing: 0) {
                        Picker("", selection: $temperature) {
                            ForEach(34..<41, id: \.self) { num in
                                Text("\(num).")
                                    .foregroundColor(.white)
                            }
                        }.pickerStyle(.wheel)
                            .frame(width: geometry.size.width/3, height: 100)
                            .compositingGroup()
                            .clipped()
                            .padding(.horizontal)
                        
                        Picker("", selection: $temperatureDecimal) {
                            ForEach(0..<10, id: \.self) { num in
                                Text("\(num)")
                                    .foregroundColor(.white)
                            }
                        }.pickerStyle(.wheel)
                            .frame(width: geometry.size.width/3, height: 100)
                            .compositingGroup()
                            .clipped()
                            .padding(.horizontal)
                    }.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 4))
                    
                    Spacer()
                    
                    Button(action: doneMonitoring,
                           label: {
                        Text("Done")
                            .font(.system(size: 30))
                            .bold()
                            .foregroundColor(.white)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.white, lineWidth:  4))
                        
                        
                    })
                }
            }.navigationBarTitle("", displayMode: .inline)
        }
    }
    
    func doneMonitoring() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView()
    }
}
