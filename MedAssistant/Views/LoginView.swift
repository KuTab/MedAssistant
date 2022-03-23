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
                    Text("Email")
                    TextField("Enter email", text: $viewModel.email)
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
                    Button("Sign In"){
                        viewModel.signIn()
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

struct LogineView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
    }
}
