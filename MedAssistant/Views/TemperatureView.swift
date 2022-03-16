//
//  TemperatureView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 19.02.2022.
//

import Foundation
import SwiftUI

struct TemperatureView: View{
    var body: some View{
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
            VStack{
                Text("Temperature")
                    .foregroundColor(.white)
                    .font(.system(size: 60))
                    .bold()
                Spacer()
            }
        }.navigationBarTitle("", displayMode: .inline)
    }
}

struct TemperatureView_Previews: PreviewProvider {
    static var previews: some View {
        TemperatureView()
    }
}
