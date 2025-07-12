//
//  LoadingView.swift
//  AuthScreen
//
//  Created by Никита Кожухов on 05.07.2025.
//

import SwiftUI

struct RootView: View {
    @State private var isLoading = true

    var body: some View {
        ZStack {
            if isLoading {
                LoadingView()
                    .transition(.opacity)
            } else {
                ContentView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isLoading = false
                }
            }
        }
    }
}


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
