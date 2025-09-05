//
//  MockAPIClient.swift
//  PhotoGalleryTests
//
//  Created by Md Alif Hossain on 5/9/25.
//

import XCTest
import Combine
import UIKit
@testable import PhotoGallery

final class MockAPIClient: APIClient {
    var dataToReturn: Data?
    var shouldFail = false
    
    func request<T>(parameters: ResourceParameters) -> AnyPublisher<T, APIError> where T : Decodable {
        fatalError("Not used in this test")
    }
    
    func downloadData(from url: URL) -> AnyPublisher<Data, APIError> {
        if shouldFail {
            return Fail(error: APIError.custom("Network error")).eraseToAnyPublisher()
        } else {
            return Just(dataToReturn ?? Data())
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }
}
