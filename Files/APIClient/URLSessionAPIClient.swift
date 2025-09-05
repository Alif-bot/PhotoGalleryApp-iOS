//
//  URLSessionAPIClient.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import Foundation
import Combine

final class URLSessionAPIClient: APIClient {
    private let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024, // 50 MB
            diskCapacity: 200 * 1024 * 1024, // 200 MB
            diskPath: "APICache"
        )
        self.session = URLSession(configuration: configuration)
    }
    
    func request<T: Decodable>(parameters: ResourceParameters) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: parameters.url) else {
            return Fail(error: APIError.missingURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = parameters.method
        request.cachePolicy = .returnCacheDataElseLoad
        parameters.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let params = parameters.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { output -> T in
                do {
                    return try JSONDecoder().decode(T.self, from: output.data)
                } catch {
                    throw APIError.custom("Decoding failed: \(error.localizedDescription)")
                }
            }
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                return .custom(error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
}

extension URLSessionAPIClient {
    func downloadData(from url: URL) -> AnyPublisher<Data, APIError> {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .mapError { APIError.custom($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
