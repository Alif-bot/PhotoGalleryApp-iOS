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
    
    private let apiClient: APIClient
    
    // MARK: - State
    @Published var photos: [Photo] = []
    @Published var selectedPhoto: Photo?
    @Published var errorMessage: String?
    @Published var isGrid: Bool = true
    
    var gridColumns: [GridItem] {
        [GridItem(.flexible(), spacing: 12),
         GridItem(.flexible(), spacing: 12)]
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - UI Events
    
    enum Event {
        case toggleLayout
    }
    
    // MARK: - Init
    
    init(
        apiClient: APIClient = URLSessionAPIClient()
    ) {
        self.apiClient = apiClient
        fetchPhotos()
    }
    
    // MARK: - Event Handler
    func eventHandler(_ event: Event) {
        switch event {
        case .toggleLayout:
            toggleView()
        }
    }
    
    func fetchPhotos() {
        let params = ResourceParameters(url: "https://picsum.photos/v2/list?page=1&limit=50")
        
        apiClient.request(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { (photos: [Photo]) in
                self.photos = photos
            }
            .store(in: &cancellables)
    }
    
    private func toggleView() {
        isGrid.toggle()
    }
}
