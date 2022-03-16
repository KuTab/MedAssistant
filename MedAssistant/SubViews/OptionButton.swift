//
//  OptionButton.swift
//  MedAssistant
//
//  Created by Egor Dadugin on 19.02.2022.
//

import Foundation
import SwiftUI

struct OptionButton<Content: View>: View {
    var title: String
    var imageName: String
    var gradient: Gradient
    var titleFontSize: CGFloat
    var destination: Content
    
    init(title: String, titleFontSize: CGFloat, imageName: String, destination: Content, startColor: Color, endColor: Color){
        self.title = title
        self.titleFontSize = titleFontSize
        self.imageName = imageName
        self.destination = destination
        self.gradient = Gradient(colors: [startColor, endColor])
    }
    
    var body: some View{
        NavigationLink(destination: destination){
            HStack{
                Image(systemName: imageName)
                    .foregroundColor(.white)
                    .font(.system(size: 25))
                Text(title)
                    .foregroundColor(.white)
                    .font(.system(size: titleFontSize))
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity,  alignment: .center)
                .background(LinearGradient(gradient: gradient, startPoint: .bottomLeading, endPoint: .topTrailing))
                .cornerRadius(20)
        }.padding()
    }
}
