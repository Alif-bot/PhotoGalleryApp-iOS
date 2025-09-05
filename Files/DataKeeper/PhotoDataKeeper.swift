//
//  PhotoDataKeeper.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import Foundation
import Combine

final class PhotoDataKeeper: PhotoDataProvider {
    static let shared = PhotoDataKeeper()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var photos: [Photo] = []
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    
    private var currentPage = 1
    private let pageSize = 50
    private var canLoadMore = true
    
    private var apiClient: APIClient {
        URLSessionAPIClient()
    }
    
    var photosPublisher: AnyPublisher<[Photo], Never> {
        $photos
            .eraseToAnyPublisher()
    }
    
    private let cacheFile = FileManager.default.temporaryDirectory.appendingPathComponent("photos_cache.json")
    
    private init() {}
    
    // MARK: - Public Methods
    
    func fetchInitialPhotos() {
        currentPage = 1
        canLoadMore = true
        photos = loadFromCache() // load cached photos immediately
        fetchPhotos()
    }
    
    func fetchNextPage() {
        guard !isLoading, canLoadMore else { return }
        currentPage += 1
        fetchPhotos()
    }
    
    // MARK: - Private Methods
    
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
                
                if self.currentPage == 1 {
                    self.photos = newPhotos
                } else {
                    self.photos.append(contentsOf: newPhotos)
                }
                
                self.isLoading = false
                self.saveToCache(self.photos)
                
                if newPhotos.count < self.pageSize {
                    self.canLoadMore = false
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Disk Caching
    
    private func saveToCache(_ photos: [Photo]) {
        do {
            let data = try JSONEncoder().encode(photos)
            try data.write(to: cacheFile)
        } catch {
            print("Failed to write cache:", error)
        }
    }
    
    private func loadFromCache() -> [Photo] {
        do {
            let data = try Data(contentsOf: cacheFile)
            return try JSONDecoder().decode([Photo].self, from: data)
        } catch {
            return []
        }
    }
}
