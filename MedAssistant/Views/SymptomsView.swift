//
//  SymptomsView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 17.03.2022.
//

import SwiftUI

struct SymptomsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isOnArray: [Bool] = []
    @State var symptomsForRows: [Symptom] = [Symptom]()
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottom, endPoint: .top).ignoresSafeArea(.all)
                VStack {
                    //                    Text("Symtops View")
                    //                        .foregroundColor(.white)
                    //                        .font(.system(size: 30))
                    //                        .bold()
                    Spacer()
                    
                    List(symptomsForRows.indices, id: \.self) { index in
//                        HStack {
//                            Text(symptomsForRows[index].name)
//                                .foregroundColor(Color.black)
//                            if isOnArray[index] {
//                                Image(systemName: "checkmark.circle.fill")
//                            }
//                        }.frame(maxWidth: .infinity, alignment: .center)
//                            .onTapGesture {
//                            isOnArray[index].toggle()
//                        }
//                        SymptomRow(symptom: symptomsForRows[index].name, isOn: $isOnArray[index])
//                            .frame(width: geometry.size.width - 10, height: 100)
//                            .background(.white.opacity(0.2))
//                            .cornerRadius(20)
                        SymptomRow(symptom: symptomsForRows[index].name, isOn: $isOnArray[index])
                            //.frame(width: geometry.size.width - 10, height: 100)
                            .background(.white.opacity(0.2))
                            .cornerRadius(20)
                    }.onAppear(perform: getSymptoms)
                    
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
                //                    .onChange(of: self.symptomsForRows) { newValue in
                //                        isOnArray = Array(repeating: false, count: self.symptomsForRows.count)
                //                    }
            }.navigationBarTitle("Symptoms", displayMode: .inline)
        }
    }
    
    func doneChoice() {
        var result : [String] = []
        for index in 0..<symptomsForRows.count {
            if isOnArray[index] {
                result.append(symptomsForRows[index].name)
            }
        }
        print(result)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func getSymptoms(){
        guard let url = URL(string: "https://telesfor.herokuapp.com/api/symptoms") else {
            print("Wrong url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error")
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            print("Get symptoms: \(response.statusCode)")
            DispatchQueue.main.async {
                do {
                    let decoder = JSONDecoder()
                    let symptomsData = try decoder.decode(Symptoms.self, from: data)
                    print(symptomsData.symptoms)
                    self.symptomsForRows = symptomsData.symptoms
                    self.isOnArray = Array(repeating: false, count: self.symptomsForRows.count)
                    print("changed")
                } catch {
                    return
                }
            }
        }
        dataTask.resume()
    }
    
}

struct SymptomsView_Previews: PreviewProvider {
    static var previews: some View {
        SymptomsView()
    }
}
