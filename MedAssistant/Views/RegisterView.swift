//
//  RegisterView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 28.03.2022.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: LoginViewModel
    var body: some View {
        HStack {
            
            Spacer()
            
            VStack {
                VStack{
                    Text("Имя")
                    TextField("Введите имя", text: $viewModel.name)
                    
                    Text("Фамилия")
                    TextField("Введите фамилию", text: $viewModel.surname)
                    
                    Text("Отчество")
                    TextField("Введите отчество", text: $viewModel.patronymic)
                    
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
                
                Button(action: {
                    viewModel.isRegistered = true
                    UserDefaults.standard.setValue(true, forKey: "IsRegistered")
                }, label: {
                    Text("У меня уже есть аккаунт")
                })
                
                if viewModel.isSigningIn {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Button("Регистрация") {
                        viewModel.register()
                    }
                    .padding()
                    .background(.green.opacity(0.8))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                }
                
                if(!viewModel.error.isEmpty) {
                    Text(viewModel.error)
                        .foregroundColor(Color.red)
                }
                
                if viewModel.preRegistered {
                    VStack {
                        VStack {
                            Text("Код подтверждения")
                            TextField("Введите код подтверждения", text: $viewModel.confirmationCode)
                        }
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        
                        Button("Подтвердить") {
                            viewModel.confirm()
                        }
                        .padding()
                        .background(.green.opacity(0.8))
                        .cornerRadius(20)
                        .foregroundColor(.white)
                    }
                }
                
            }
            .padding(.horizontal, 30)
            .frame(maxWidth: 400.0)
            
            Spacer()
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: LoginViewModel())
    }
}
