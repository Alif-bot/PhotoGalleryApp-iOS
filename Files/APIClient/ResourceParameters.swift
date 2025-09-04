//
//  ResourceParameters.swift
//  PhotoGallery
//
//  Created by Md Alif Hossain on 4/9/25.
//

import Foundation

struct ResourceParameters {
    let url: String
    let method: String
    let parameters: [String: Any]?
    let headers: [String: String]?
    
    init(
        url: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil
    ) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
}
