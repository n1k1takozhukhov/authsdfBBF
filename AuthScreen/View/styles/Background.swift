//
//  Background.swift
//  AuthScreen
//
//  Created by Никита Кожухов on 02.07.2025.
//

import SwiftUI

struct Background: View {
    
    var body: some View {
        ZStack {
            
            Color(red: 251/255, green: 146/255, blue: 37/255, opacity: 1)
                .ignoresSafeArea()
            
            Image("backgroundSingature")
                .resizable()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    Background()
}
