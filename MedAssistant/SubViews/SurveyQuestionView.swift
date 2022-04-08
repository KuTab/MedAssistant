//
//  SurveyQuestionView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 08.04.2022.
//

import SwiftUI

struct SurveyQuestionView: View {
    var surveyQuestion: SurveyQuestion
    @Binding var selectedValue: String
    
    var body: some View {
        VStack {
            Text(surveyQuestion.title)
            Picker(surveyQuestion.title, selection: $selectedValue) {
                ForEach(Options.allCases) {
                    option in Text(String(option.rawValue))
                }
            }
            .pickerStyle(.segmented)
            .padding()
            HStack {
                Text(surveyQuestion.leftBound)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                Spacer()
                Text(surveyQuestion.rightBound)
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 5)
            .padding(.horizontal,20)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
    }
}

struct SurveyQuestionView_Previews: PreviewProvider {
    @State static var previewTest: String = "0"
    static var previews: some View {
        SurveyQuestionView(surveyQuestion: surveyQuestions[0], selectedValue: $previewTest)
    }
}
