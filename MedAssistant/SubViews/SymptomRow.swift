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
    
    var body: some View {
        HStack{
            Toggle(isOn: $isOn, label: {
                Text(symptom)
                    .foregroundColor(.black)
                    .font(.system(size: 30))
            }).padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                //.toggleStyle(.button)
        }
    }
}

struct SymptomRow_Previews: PreviewProvider {
    @State static var previewTest: Bool = false
    
    static var previews: some View {
        SymptomRow(isOn: $previewTest)
            .previewLayout(.sizeThatFits)
    }
}
