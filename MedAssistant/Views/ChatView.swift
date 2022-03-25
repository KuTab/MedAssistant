//
//  ChatView.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 19.02.2022.
//

import Foundation
import SwiftUI

struct ChatView: View {
    //Message text here
    @State private var messageText = ""
    
    //Array of messages
    @State var messages: [String] = ["Welcome to chat bot"]
    
    var body: some View {
        VStack {
            HStack {
                Text("Chat bot")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color.white)
                
                Image(systemName: "bubble.left.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color.white)
                
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.teal]), startPoint: .bottomLeading, endPoint: .topTrailing))//HSTACK
            
            ScrollView {
                //Messages
                ForEach(messages, id: \.self) { message in
                    if message.contains("[USER]") {
                        let newMessage = message.replacingOccurrences(of: "[USER]", with: "")
                        
                        HStack {
                            Spacer()
                            Text(newMessage)
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }
                    } else {
                        HStack {
                            Text(message)
                                .padding()
                                .background(.gray.opacity(0.15))
                                .cornerRadius(10)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                            Spacer()
                        }
                    }
                }.rotationEffect(.degrees(180))
            }.rotationEffect(.degrees(180))
                .background(Color.gray.opacity(0.10))
            
            HStack {
                TextField("Type something here", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .onSubmit {
                        sendMessage(message: messageText)
                    }
                
                Button {
                    sendMessage(message: messageText)
                } label:{
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.blue)
                }
                .font(.system(size: 26))
                .padding(.horizontal, 10)
            }
            .padding()
            
        }.navigationBarTitle("", displayMode: .inline)//VSTACK
    }
    
    func sendMessage(message: String){
        if(message.isEmpty) {
            return
        }
        withAnimation {
            messages.append("[USER]" + message)
            self.messageText = ""
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                messages.append(getBotResponse(message: message))
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
