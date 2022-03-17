//
//  SymptomRow.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 17.03.2022.
//

import SwiftUI

struct SymptomRow: View {
    var symptom: String = "Test"
    @State private var isOn: Bool = false
    
    var body: some View {
        HStack{
            Toggle(isOn: $isOn, label: {
                Text(symptom)
                    .foregroundColor(.white)
                    .font(.system(size: 30))
            }).padding()
                //.toggleStyle(.button)
        }
    }
}

struct SymptomRow_Previews: PreviewProvider {
    static var previews: some View {
        SymptomRow()
            .previewLayout(.sizeThatFits)
    }
}
