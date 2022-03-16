//
//  TemperatureView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 19.02.2022.
//

import Foundation
import SwiftUI

struct TemperatureView: View{
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
            VStack{
                Text("Temperature")
                    .foregroundColor(.white)
                    .font(.system(size: 60))
                    .bold()
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
    
    func doneMonitoring(){
        presentationMode.wrappedValue.dismiss()
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView()
    }
}
