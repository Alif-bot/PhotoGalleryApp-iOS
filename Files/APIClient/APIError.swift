//
//  APIError.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import Foundation

enum APIError: LocalizedError, Decodable {
    case custom(String)
    case noResult
    case missingURL
    case emptyResult
    case downloadError
    case apiError(Error)
    
    private enum CodingKeys: String, CodingKey {
        case error
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let errorMessage = try? container.decode(String.self, forKey: .error) {
            self = .custom(errorMessage)
        } else {
            self = .custom("Unknown error")
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .custom(let message): return message
        case .noResult: return "No result returned."
        case .missingURL: return "The URL is missing."
        case .emptyResult: return "The result was empty."
        case .downloadError: return "Download failed."
        case .apiError(let error): return error.localizedDescription
        }
    }
}
