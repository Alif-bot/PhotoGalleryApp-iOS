//
//  URLSessionAPIClient.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import Foundation
import Combine

final class URLSessionAPIClient: APIClient {
    func request<T: Decodable>(parameters: ResourceParameters) -> AnyPublisher<T, APIError> {
        guard let url = URL(string: parameters.url) else {
            return Fail(error: APIError.missingURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = parameters.method
        parameters.headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let params = parameters.parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
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
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .mapError { APIError.custom($0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
