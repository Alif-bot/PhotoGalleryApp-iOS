//
//  PhotoDetailViewModelTests.swift
//  PhotoGalleryTests
//
//  Created by Md Alif Hossain on 5/9/25.
//

import XCTest
import Combine
import UIKit
@testable import PhotoGallery

final class PhotoDetailViewModelTests: XCTestCase {
    
    var viewModel: PhotoDetailViewModel!
    var mockAPIClient: MockAPIClient!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        
        mockAPIClient = MockAPIClient()
        let photo = Photo(
            id: "1",
            author: "Author",
            width: 100,
            height: 100,
            url: "",
            download_url: "https://example.com/image.jpg"
        )
        
        // Inject mock API client via initializer
        viewModel = PhotoDetailViewModel(photo: photo, apiClient: mockAPIClient)
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIClient = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testResetZoom() {
        viewModel.scale = 2.0
        viewModel.offset = CGSize(width: 50, height: 50)
        viewModel.lastOffset = CGSize(width: 20, height: 20)
        
        viewModel.resetZoom()
        
        XCTAssertEqual(viewModel.scale, 1.0)
        XCTAssertEqual(viewModel.offset, .zero)
        XCTAssertEqual(viewModel.lastOffset, .zero)
    }
    
    func testLoadUIImageSuccess() {
        // Given
        let expectation = XCTestExpectation(description: "Image loaded")
        let testImage = UIImage(systemName: "star")!
        mockAPIClient.dataToReturn = testImage.pngData()
        
        viewModel.$image
            .dropFirst()
            .sink { image in
                if image != nil { expectation.fulfill() }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.loadUIImage()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNotNil(viewModel.image)
    }
    
    func testLoadUIImageFailure() {
        // Given
        mockAPIClient.shouldFail = true
        let expectation = XCTestExpectation(description: "Error received")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                if error != nil { expectation.fulfill() }
            }
            .store(in: &cancellables)
        
        // When
        viewModel.loadUIImage()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.errorMessage, "Network error")
    }
    
    func testShareItemsReturnsImage() {
        let testImage = UIImage(systemName: "star")!
        viewModel.image = testImage
        
        let items = viewModel.shareItems()
        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(items.first is UIImage)
    }
    
    func testShareItemsReturnsEmptyWhenNoImage() {
        viewModel.image = nil
        let items = viewModel.shareItems()
        XCTAssertTrue(items.isEmpty)
    }
}
