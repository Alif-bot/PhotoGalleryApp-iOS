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
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        WebImageView(
            url: photo.download_url,
            width: width,
            height: height
        )
    }
}

#Preview {
    PhotoCellView(
        photo: Photo(
            id: "0",
            author: "Alejandro Escamilla",
            width: 300,
            height: 300,
            url: "https://unsplash.com/photos/yC-Yzbqy7PY",
            download_url: "https://picsum.photos/id/0/500/300"
        ),
        width: 150,
        height: 150
    )
}
