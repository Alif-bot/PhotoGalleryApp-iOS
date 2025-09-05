//
//  PhotoGalleryViewModel.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import Foundation
import Combine
import SwiftUI

final class PhotoGalleryViewModel: ObservableObject {
    
    // MARK: - Dependencies
    private let dataProvider: any PhotoDataProvider
    
    // MARK: - State
    @Published var photos: [Photo] = []
    @Published var selectedPhoto: Photo?
    @Published var errorMessage: String?
    @Published var isGrid: Bool = true
    @Published var isLoadingPage = false
    
    // Pagination
    private var currentPage = 2
    private let pageSize = 50
    private var canLoadMore = true
    
    // Grid layout
    var gridColumns: [GridItem] {
        [GridItem(.flexible(), spacing: 12),
         GridItem(.flexible(), spacing: 12)]
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Events
    
    enum Event {
        case toggleLayout
        case loadNextPage(Photo)
    }
    
    // MARK: - Init
    
    init(
        dataProvider: any PhotoDataProvider = PhotoDataKeeper.shared
    ) {
        self.dataProvider = dataProvider
        self.photos = dataProvider.photos
        
        // Subscribe to updates via the publisher
        dataProvider.photosPublisher
            .sink { [weak self] newPhotos in
                self?.photos = newPhotos
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Event Handler
    func eventHandler(_ event: Event) {
        switch event {
        case .toggleLayout:
            toggleView()
        case .loadNextPage(let photo):
            loadNextPageIfNeeded(currentPhoto: photo)
        }
    }
    
    private func toggleView() {
        isGrid.toggle()
    }
    
    private func loadNextPageIfNeeded(currentPhoto: Photo) {
        guard let last = photos.last, currentPhoto.id == last.id, canLoadMore else { return }
        dataProvider.fetchNextPage()
    }
}
