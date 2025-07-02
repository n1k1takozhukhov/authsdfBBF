//
//  LoadingScene.swift
//  AuthScreen
//
//  Created by Никита Кожухов on 02.07.2025.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Background()
            
            Image("starRight")
                .resizable()
                .frame(width: 236.16, height: 236.16)
        }
    }
}

#Preview {
    LoadingView()
}
