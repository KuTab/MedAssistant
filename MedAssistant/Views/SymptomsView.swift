//
//  SymptomsView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 17.03.2022.
//

import SwiftUI

struct SymptomsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader{ geometry in
            ZStack{
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
                VStack{
                    Text("Symtops View")
                        .foregroundColor(.white)
                        .font(.system(size: 60))
                        .bold()
                    ScrollView{
                        VStack{
                            ForEach(symptoms, id: \.self){ symptom in
                                Text(symptom)
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                                    .padding()
                                    .frame(width: geometry.size.width - 10, height: 100)
                                    .background(.white.opacity(0.2))
                                    .cornerRadius(20)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: doneChoice,
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
    
    func doneChoice(){
        presentationMode.wrappedValue.dismiss()
    }
}

struct SymptomsView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomsView()
    }
}
