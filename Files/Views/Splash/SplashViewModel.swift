//
//  SplashViewModel.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import SwiftUI
import Combine

final class SplashViewModel: ObservableObject {
    @Published var isActive = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadInitialPhotos()
    }
    
    private func loadInitialPhotos() {
        let keeper = PhotoDataKeeper.shared
        keeper.fetchInitialPhotos()
        
        keeper.$photos
            .compactMap { $0.isEmpty ? nil : $0 }
            .first()
            .sink { [weak self] _ in
                withAnimation {
                    self?.isActive = true
                }
            }
            .store(in: &cancellables)
    }
}
