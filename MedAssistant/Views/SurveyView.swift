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
    @State private var answers: [String] = Array(repeating: "0", count: 30)
    var availableDate = UserDefaults.standard.object(forKey: "surveyDate") as? Date ?? Date.now
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        //ZStack {
        //LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottomLeading, endPoint: .topTrailing)
        //.ignoresSafeArea(.all)
        if Date.now >= availableDate {
        VStack {
            Text("Опрос")
                .font(.title)
                .bold()
            ScrollView{
                ForEach(surveyQuestions.indices) { index in
                    SurveyQuestionView(surveyQuestion: surveyQuestions[index], selectedValue: $answers[index])
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
            }.safeAreaInset(edge: .bottom) {
                HStack{
                    Button(action: submitAnswers,
                           label: {
                        Text("Отправить")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.green.opacity(0.8))
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    })
                }.padding(.horizontal)
                    .padding(.top, 10)
                .background(.ultraThinMaterial)
            }
        }.navigationBarTitle("", displayMode: .inline)
            .onChange(of: picker1) { newValue in
                print(newValue)
            }
        } else {
            Text("В следующий раз опрос можно пройти \(formatDate(date: availableDate))")
        }
        //}.navigationBarTitle("", displayMode: .inline)
    }
    
    func submitAnswers() {
        print(answers)
        APIWorker.shared.getUserID() { result in
            switch result {
            case .success(let resultId):
                APIWorker.shared.sendAnswers(id: resultId, answers: answers)
            case .failure(_):
                print("failure")
                LoginViewModel.shared.isLoggedIn = false
                UserDefaults.standard.setValue(false, forKey: "IsLoggedIn")
            }
        }
        
        let date = Date.now
        var finalDate = Calendar.current.date(byAdding: .month, value: 1, to: date)
        finalDate = Calendar.current.startOfDay(for: finalDate!)
        
        UserDefaults.standard.setValue(finalDate, forKey: "surveyDate")
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
}

struct SurveyView_Previews: PreviewProvider {
    static var previews: some View {
        SurveyView()
    }
}
