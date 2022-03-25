//
//  ContentView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 02.01.2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                VStack {
                    
                    HStack {
                        
                        OptionButton(title: "Chat", titleFontSize: 30, imageName: "bubble.left.and.bubble.right.fill", destination: ChatView(), startColor: .purple, endColor: .cyan)
                        
                        OptionButton(title: "Survey", titleFontSize: 30, imageName: "questionmark.square.fill", destination: SurveyView(), startColor: .red, endColor: .orange)
                    }
                    
                    HStack {
                        
                        OptionButton(title: "Temperature", titleFontSize: 20, imageName: "thermometer", destination: TemperatureView(), startColor: .green, endColor: .teal)
                        
                        OptionButton(title: "Weight", titleFontSize: 30, imageName: "thermometer", destination: WeightView(), startColor: .pink, endColor: .mint)
                    }
                    
                    HStack {
                        
                        OptionButton(title: "Symptoms", titleFontSize: 20, imageName: "thermometer", destination: SymptomsView(), startColor: .green, endColor: .teal)
                    }
                    
                    HStack {
                        
                        OptionButton(title: "Calendar", titleFontSize: 20, imageName: "calendar",
                                     destination: CalendarView(), startColor: .purple, endColor: .indigo)
                    }
                    
                    HStack {
                        
                        OptionButton(title: "Profile", titleFontSize: 20, imageName: "person.fill",
                                     destination: ProfileView(), startColor: .red, endColor: .orange)
                    }
                }
            }.navigationBarHidden(true)
        }
    }
}

struct ContentView: View {
    @StateObject var loginVM = LoginViewModel()
    
    var body: some View {
        
        if loginVM.isLoggedIn {
                
                MainView()
        } else {
            
            LoginView(viewModel: loginVM)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        MainView()
    }
}
