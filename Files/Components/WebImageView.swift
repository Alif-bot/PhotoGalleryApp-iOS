//
//  WebImageView.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct WebImageView: View {
    let url: String
    var cornerRadius: CGFloat = 8
    
    @State private var isImageLoaded = false
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: url))
                .resizable()
                .scaledToFill()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .background(
                    Group {
                        if isLoading {
                            Color.gray.opacity(0.2)
                        }
                        if !isImageLoaded && !isLoading {
                            Color.gray.opacity(0.3)
                                .overlay(
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(8)
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                )
        }
    }
}
