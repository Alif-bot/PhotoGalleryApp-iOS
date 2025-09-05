//
//  PhotoGalleryViewModelTests.swift
//  PhotoGalleryTests
//
//  Created by Md Alif Hossain on 5/9/25.
//

import XCTest
import Combine
@testable import PhotoGallery

final class PhotoGalleryViewModelTests: XCTestCase {
    
    var viewModel: PhotoGalleryViewModel!
    var mockProvider: MockPhotoDataProvider!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        mockProvider = MockPhotoDataProvider()
        viewModel = PhotoGalleryViewModel(dataProvider: mockProvider!)
    }
    
    override func tearDown() {
        viewModel = nil
        mockProvider = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testInitialPhotosAreLoaded() {
        // Given
        let expectation = XCTestExpectation(description: "Photos updated in ViewModel")
        
        viewModel.$photos
            .dropFirst()
            .sink { photos in
                if photos.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        mockProvider.fetchInitialPhotos()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.photos.count, 2)
        XCTAssertEqual(viewModel.photos.first?.author, "Mock Author 1")
    }
    
    func testToggleLayoutChangesIsGrid() {
        // Given
        let initial = viewModel.isGrid
        
        // When
        viewModel.eventHandler(.toggleLayout)
        
        // Then
        XCTAssertNotEqual(viewModel.isGrid, initial)
    }
    
    func testLoadNextPageAppendsPhoto() {
        // Given
        mockProvider.photos = [
            Photo(id: "1", author: "Author1", width: 100, height: 100, url: "", download_url: "")
        ]
        
        let expectation = XCTestExpectation(description: "Next page loaded")
        viewModel.$photos
            .dropFirst()
            .sink { photos in
                if photos.count == 2 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // When
        if let lastPhoto = viewModel.photos.last {
            viewModel.eventHandler(.loadNextPage(lastPhoto))
        }
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.photos.count, 2)
        XCTAssertEqual(viewModel.photos.last?.author, "Mock Author 2")
    }
}
