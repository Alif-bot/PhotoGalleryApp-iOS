//
//  PhotoDataProvider.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 5/9/25.
//

import Foundation
import Combine

protocol PhotoDataProvider: ObservableObject {
    var photos: [Photo] { get set }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var photosPublisher: AnyPublisher<[Photo], Never> { get }
    
    func fetchInitialPhotos()
    func fetchNextPage()
}
