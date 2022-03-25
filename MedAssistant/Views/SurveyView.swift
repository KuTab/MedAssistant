//
//  SurveyView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 19.02.2022.
//

import Foundation
import SwiftUI

enum Options: String, CaseIterable, Identifiable {
    case veryPoor = "-3"
    case poor = "-2"
    case notoOk = "-1"
    case normal = "0"
    case ok = "1"
    case good = "2"
    case veryGood = "3"
    
    var id: String {self.rawValue}
}

struct SurveyView: View {
    @State private var picker1: String = ""
    
    var body: some View {
        //ZStack {
           //LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottomLeading, endPoint: .topTrailing)
                //.ignoresSafeArea(.all)
            
            VStack {
                Text("Оцените ваше самочувствие")
                Picker("Оцените ваше самочувствие", selection: $picker1) {
                    ForEach(Options.allCases) {
                        option in Text(String(option.rawValue))
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                HStack {
                    Text("Самочувствие\nплохое")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                    Spacer()
                    Text("Самочувствие хорошее")
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 0)
                .padding(.horizontal,20)
                Button("Далее") {
                    UserDefaults.standard.removeObject(forKey: "IsLoggedIn")
                }
                .padding()
                .frame(width: 200, height: 50, alignment: .center)
                .background(.green.opacity(0.8))
                .cornerRadius(20)
                .foregroundColor(.white)
            }.navigationBarTitle("", displayMode: .inline)
        //}.navigationBarTitle("", displayMode: .inline)
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
