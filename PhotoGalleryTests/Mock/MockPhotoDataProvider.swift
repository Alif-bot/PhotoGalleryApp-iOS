//
//  MockPhotoDataProvider.swift
//  PhotoGalleryTests
//
//  Created by Md Alif Hossain on 5/9/25.
//

import Combine
@testable import PhotoGallery

final class MockPhotoDataProvider: PhotoDataProvider {
    
    @Published var photos: [Photo] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String? = nil
    
    var photosPublisher: AnyPublisher<[Photo], Never> {
        $photos.eraseToAnyPublisher()
    }
    
    func fetchInitialPhotos() {
        let initialPhotos = [
            Photo(id: "1", author: "Mock Author 1", width: 100, height: 100, url: "", download_url: ""),
            Photo(id: "2", author: "Mock Author 2", width: 100, height: 100, url: "", download_url: "")
        ]
        photos = initialPhotos
    }
    
    func fetchNextPage() {
        let nextPhoto = Photo(id: "\(photos.count + 1)", author: "Mock Author \(photos.count + 1)", width: 100, height: 100, url: "", download_url: "")
        photos.append(nextPhoto)
    }
}
