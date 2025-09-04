//
//  PhotoCellView.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PhotoCellView: View {
    let photo: Photo
    var height: CGFloat = 150
    var width: CGFloat? = nil
    
    var body: some View {
        WebImage(url: URL(string: photo.download_url))
            .resizable()
            .scaledToFill()
            .frame(
                width: width,
                height: height
            )
            .frame(maxWidth: width == nil ? .infinity : nil)
            .clipped()
            .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 20) {
        // Grid style
        PhotoCellView(
            photo: Photo(
                id: "0",
                author: "Alejandro Escamilla",
                width: 300,
                height: 300,
                url: "https://unsplash.com/photos/yC-Yzbqy7PY",
                download_url: "https://picsum.photos/id/0/500/300"
            ),
            height: 150,
            width: 150
        )
        
        // List style
        PhotoCellView(
            photo: Photo(
                id: "1",
                author: "Alejandro Escamilla",
                width: 500,
                height: 300,
                url: "https://unsplash.com/photos/yC-Yzbqy7PY",
                download_url: "https://picsum.photos/id/1/500/300"
            ),
            height: 200
        )
    }
    .padding()
}
