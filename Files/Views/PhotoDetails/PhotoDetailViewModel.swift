//
//  PhotoDetailViewModel.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI

final class PhotoDetailViewModel: ObservableObject {
    @Published var scale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero
    
    @Published var errorMessage: String?
    
    let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    func resetZoom() {
        scale = 1.0
        offset = .zero
        lastOffset = .zero
    }
}
