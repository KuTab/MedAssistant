//
//  SymptomRow.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 17.03.2022.
//

import SwiftUI

struct SymptomRow: View {
    var symptom: String = "Test"
    @Binding var isOn: Bool
    @Binding var severity: Int
    
    var body: some View {
        HStack{
                Text(symptom)
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                //.toggleStyle(.button)
            Picker("Severity", selection: $severity){
                ForEach(0..<6, id: \.self) { num in
                    Text("\(num)")
                        .foregroundColor(.black)//.white
                }
            }.pickerStyle(.menu)
        }
    }
}

struct SymptomRow_Previews: PreviewProvider {
    @State static var previewTest: Bool = false
    @State static var previewSeverity: Int = 0
    
    static var previews: some View {
        SymptomRow(isOn: $previewTest, severity: $previewSeverity)
            .previewLayout(.sizeThatFits)
    }
}
