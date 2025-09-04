//
//  PhotoDetailViewModel.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine
import Photos

final class PhotoDetailViewModel: ObservableObject {
    @Published var scale: CGFloat = 1.0
    @Published var lastScale: CGFloat = 1.0
    @Published var offset: CGSize = .zero
    @Published var lastOffset: CGSize = .zero
    @Published var errorMessage: String?
    @Published var image: UIImage?
    @Published var isSharePresented = false
    @Published var showToast: Bool = false
    
    private var apiClient: APIClient {
        URLSessionAPIClient()
    }
    
    let photo: Photo
    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo) {
        self.photo = photo
        loadUIImage()
    }
    
    func resetZoom() {
        scale = 1.0
        offset = .zero
        lastOffset = .zero
    }
    
    // MARK: - Load image
    func loadUIImage() {
        guard let url = URL(string: photo.download_url) else { return }
        
        apiClient.downloadData(from: url)
            .map { UIImage(data: $0) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Save to Gallery
    
    func saveToGallery() {
        guard let uiImage = image else { return }
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: uiImage)
        } completionHandler: { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    self?.showToast = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.showToast = false
                    }
                } else {
                    self?.errorMessage = error?.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Share
    func shareItems() -> [Any] {
        guard let uiImage = image else { return [] }
        return [uiImage]
    }
}
