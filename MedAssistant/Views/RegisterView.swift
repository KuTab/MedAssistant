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
                    Text("Name")
                    TextField("Enter name", text: $viewModel.name)
                    
                    Text("Surname")
                    TextField("Enter surname", text: $viewModel.surname)
                    
                    Text("Patronymic")
                    TextField("Enter patronymic", text: $viewModel.patronymic)
                    
                    Text("Phone")
                    TextField("Enter phone number", text: $viewModel.phone)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                    
                    Text("Password")
                    SecureField("Enter password", text: $viewModel.password)
                    
                }
                .padding()
                .textFieldStyle(.roundedBorder)
                .disabled(viewModel.isSigningIn)
                
                if viewModel.isSigningIn {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Button("Register") {
                        viewModel.register()
                    }
                    .padding()
                    .background(.green.opacity(0.8))
                    .cornerRadius(20)
                    .foregroundColor(.white)
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
