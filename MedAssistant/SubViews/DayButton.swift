//
//  DayButton.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 30.03.2022.
//

import SwiftUI

struct DayButton: View {
    @Binding var isSelected: Bool
    var dayName: String
    var body: some View {
        Button(action: { isSelected.toggle() },
               label: { Text(dayName)
                .frame(maxWidth: .infinity)
                .foregroundColor(isSelected ? Color.white : Color.gray.opacity(0.8))
                .padding()
                .background(isSelected ? Color.blue : Color.clear)
                .clipShape(Circle())
        })
    }
}

struct DayButton_Previews: PreviewProvider {
    @State static var previewTest: Bool = false
    
    static var previews: some View {
        DayButton(isSelected: $previewTest, dayName: "Mon")
    }
}
