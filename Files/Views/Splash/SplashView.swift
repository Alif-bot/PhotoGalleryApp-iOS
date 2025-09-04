//
//  SplashView.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    
    var body: some View {
        Group {
            if viewModel.isActive {
                PhotoGalleryView(viewModel: PhotoGalleryViewModel())
            } else {
                VStack {
                    LottieView(
                        animationName: "splashAnimation",
                        loopMode: .playOnce,
                        animationSpeed: 1.3
                    )
                    .frame(width: 180, height: 180)
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
