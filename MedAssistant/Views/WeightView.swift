//
//  WeightView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 16.03.2022.
//

import SwiftUI

struct WeightView: View {
    @State private var weight: Int = 75
    @State private var weightDecimal: Int = 5
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        GeometryReader{geometry in
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
                VStack{
                    Text("Weight")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .bold()
                    Spacer()
                    
                    HStack(spacing: 0){

                        Picker("", selection: $weight){
                            ForEach(0..<150, id: \.self) { num in
                                Text("\(num).")
                                    .foregroundColor(.white)
                            }
                        }.pickerStyle(.wheel)
                            .frame(width: geometry.size.width/3, height: 100)
                            .compositingGroup()
                            .clipped()
                            .padding(.horizontal)
                        
                        Picker("", selection: $weightDecimal){
                            ForEach(0..<10, id: \.self) { num in
                                Text("\(num)")
                                    .foregroundColor(.white)
                            }
                        }.pickerStyle(.wheel)
                            .frame(width: geometry.size.width/3, height: 100)
                            .compositingGroup()
                            .clipped()
                            .padding(.horizontal)
                    }.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white, lineWidth: 4))
                    
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
    }
    
    func doneMonitoring(){
        presentationMode.wrappedValue.dismiss()
    }
}

struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        WeightView()
    }
}
