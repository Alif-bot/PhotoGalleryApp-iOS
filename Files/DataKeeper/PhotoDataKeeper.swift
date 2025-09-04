//
//  PhotoDataKeeper.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import Foundation
import Combine

final class PhotoDataKeeper: ObservableObject {
    static let shared = PhotoDataKeeper()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var photos: [Photo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var currentPage = 1
    private let pageSize = 50
    private var canLoadMore = true
    
    private var apiClient: APIClient {
        URLSessionAPIClient()
    }
    
    private init() {}
    
    func fetchInitialPhotos() {
        currentPage = 1
        canLoadMore = true
        photos = []
        fetchPhotos()
    }
    
    func fetchNextPage() {
        guard !isLoading, canLoadMore else { return }
        currentPage += 1
        fetchPhotos()
    }
    
    private func fetchPhotos() {
        guard canLoadMore else { return }
        isLoading = true
        
        let url = "https://picsum.photos/v2/list?page=\(currentPage)&limit=\(pageSize)"
        let params = ResourceParameters(url: url)
        
        apiClient.request(parameters: params)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] (newPhotos: [Photo]) in
                guard let self = self else { return }
                
                self.photos.append(contentsOf: newPhotos)
                self.isLoading = false
                
                // Stop pagination if fewer items than requested
                if newPhotos.count < self.pageSize {
                    self.canLoadMore = false
                }
            }
            .store(in: &cancellables)
    }
}
