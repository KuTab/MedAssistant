//
//  CalendarView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 23.03.2022.
//

import SwiftUI

struct CalendarView: View {
    @State var currentDate: Date = Date()
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 20) {
                
                //Custom date picker
                CustomDatePickerView(currentDate: $currentDate)
            }.padding(.vertical)
        }.safeAreaInset(edge: .bottom) {
            
            HStack {
                
                NavigationLink(destination: AddDrugTakeView()){
                    Text("Добавить лекарство")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.green, in: Capsule())
                        .foregroundColor(.white)
                }//.frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity,  alignment: .center)
                
                NavigationLink(destination: AddDoctorVisitView()){
                    Text("Добавить посещение")
                        .font(.system(size: 14))
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                        .background(Color.green, in: Capsule())
                        .foregroundColor(.white)
                }
                
                //                Button {
                //                    //ToDo
                //                } label: {
                //                    Text("Add Drug")
                //                        .fontWeight(.bold)
                //                        .padding(.vertical)
                //                        .frame(maxWidth: .infinity)
                //                        .background(Color.green, in: Capsule())
                //                        .foregroundColor(.white)
                //                }
            }.padding(.horizontal)
                .padding(.top, 10)
                .background(.ultraThinMaterial)
        }.navigationBarTitle("", displayMode: .inline)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
