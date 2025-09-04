//
//  APIClient.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import Foundation
import Combine

protocol APIClient {
    func request<T: Decodable>(parameters: ResourceParameters) -> AnyPublisher<T, APIError>
    func downloadData(from url: URL) -> AnyPublisher<Data, APIError>
}
