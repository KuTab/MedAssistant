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
    
    //all Health records about weight
    @FetchRequest(sortDescriptors: []) private var weightData: FetchedResults<Weight>
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            //ZStack {
                //LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
            VStack {
                    Text("Weight")
                        .foregroundColor(.blue)//.white
                        .font(.system(size: 60))
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                
                    Spacer()
                    
                    HStack(spacing: 0) {

                        Picker("", selection: $weight) {
                            ForEach(0..<150, id: \.self) { num in
                                Text("\(num).")
                                    .foregroundColor(.black)//.white
                            }
                        }.pickerStyle(.wheel)
                            .frame(width: geometry.size.width/3, height: 100)
                            .compositingGroup()
                            .clipped()
                            .padding(.horizontal)
                        
                        Picker("", selection: $weightDecimal) {
                            ForEach(0..<10, id: \.self) { num in
                                Text("\(num)")
                                    .foregroundColor(.black)//.white
                            }
                        }.pickerStyle(.wheel)
                            .frame(width: geometry.size.width/3, height: 100)
                            .compositingGroup()
                            .clipped()
                            .padding(.horizontal)
                    }.overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.black, lineWidth: 4))//.white
                    
                    Spacer()
                    
                    Button(action: doneMonitoring,
                           label: {
                        Text("Done")
                            .font(.system(size: 30))
                            .bold()
                            .foregroundColor(.black)//.white
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth:  4))//.white
                        
                        
                    })
                }.navigationBarTitle("", displayMode: .inline)
            //}.navigationBarTitle("", displayMode: .inline)
        }
    }
    
    func doneMonitoring() {
        let todayWeight = Weight(context: moc)
        todayWeight.value = Double(weight) + Double(weightDecimal) * 0.1
        todayWeight.date = Date.now
        
        //can throw exception
        try? moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct WeightView_Previews: PreviewProvider {
    static var previews: some View {
        WeightView()
    }
}
