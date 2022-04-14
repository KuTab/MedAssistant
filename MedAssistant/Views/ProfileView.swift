//
//  ProfileView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 25.03.2022.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var profileData = ProfileModel()
    @State var isEditing: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading)  {
            
            HStack{
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Spacer()
            }.padding()
            
            HStack {
                
                Text("Имя: ")
                    .font(.title.bold())
                
                if(isEditing) {
                    
                    TextField("Имя", text: $profileData.name)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                } else {
                    
                    Text(profileData.name)
                        .font(.title.bold())
                        .padding(.vertical, 7)
                        .padding(.horizontal, 5)
                }
            }.padding()
            
            HStack {
                
                Text("Фамилия: ")
                    .font(.title.bold())
                
                if(isEditing) {
                    
                    TextField("Фамилия", text: $profileData.surname)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                } else {
                    
                    Text(profileData.surname)
                        .font(.title.bold())
                        .padding(.vertical, 7)
                        .padding(.horizontal, 5)
                }
            }.padding()
            
            HStack {
                
                Text("Возраст: ")
                    .font(.title.bold())
                
                if(isEditing) {
                    
                    TextField("Возраст", text: $profileData.age)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                } else {
                    
                    Text(profileData.age)
                        .font(.title.bold())
                        .padding(.vertical, 7)
                        .padding(.horizontal, 5)
                }
            }.padding()
            
            Spacer()
            
            Button {
                
                if(isEditing) {
                    profileData.save()
                }
                
                isEditing.toggle()
            } label: {
                
                HStack {
                    
                    Text(isEditing ? "Сохранить" : "Редактировать")
                        .fontWeight(.bold)
                    
                    Image(systemName: "pencil")
                }.padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background(Color.green, in: Capsule())
                    .foregroundColor(Color.white)
            }.padding()
        }.navigationBarTitle("", displayMode: .inline)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
