//
//  LoginView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 19.02.2022.
//

import Foundation
import SwiftUI

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                VStack{
                    Text("Номер телефона")
                    TextField("Введите номер телефона", text: $viewModel.phone)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                    
                    Text("Пароль")
                    SecureField("Введите пароль", text: $viewModel.password)
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.isSigningIn)
                
                if(!viewModel.error.isEmpty){
                    Text(viewModel.error)
                        .foregroundColor(Color.red)
                }
                
                Button(action: {
                    viewModel.isRegistered = false
                    UserDefaults.standard.setValue(false, forKey: "IsRegistered")
                }, label: {
                    Text("У меня нет аккаунта")
                })
                
                if viewModel.isSigningIn {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Button("Вход") {
                        viewModel.signIn()
                    }
                    .padding()
                    .background(.green.opacity(0.8))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .disabled(viewModel.phone.isEmpty && viewModel.password.isEmpty)
                }
                
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: 400.0)
            
            Spacer()
        }
    }
}

struct LogineView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
