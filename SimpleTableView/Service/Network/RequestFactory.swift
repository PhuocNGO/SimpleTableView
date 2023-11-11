//
//  RequestFactory.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

final class RequestFactory {
    // Enumeration to represent HTTP methods
    enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    /// Create a URLRequest with the specified HTTP method and URL.
    ///
    /// - Parameters:
    ///   - method: The HTTP method to use.
    ///   - url: The URL for the request.
    /// - Returns: A URLRequest configured with the specified method and URL.
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
