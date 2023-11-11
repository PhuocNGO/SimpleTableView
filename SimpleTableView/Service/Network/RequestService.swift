//
//  RequestService.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

final class RequestService {
    
    // Base URL for requests
    static let baseURL = "https://jsonplaceholder.typicode.com"
    
    /// Load data from a specified URL using URLSession.
    ///
    /// - Parameters:
    ///   - urlString: The string representation of the URL to load data from.
    ///   - session: The URLSession to use for the data task. Default is a new session with default configuration.
    ///   - completion: A closure to be called with the result of the data loading operation.
    /// - Returns: The URLSessionTask representing the data task. Nil if the URL is invalid.
    func loadData(urlString: String,
                  session: URLSession = URLSession(configuration: .default),
                  completion: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask? {
        
        // Validate URL
        guard let url = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong URL format")))
            return nil
        }
        
        // Create URLRequest using RequestFactory
        let request = RequestFactory.request(method: .get, url: url)
        
        // Perform data task
        let task = session.dataTask(with: request) { (data, response, error) in
            // Handle errors
            if let error = error {
                completion(.failure(.network(string: "Error during data loading: " + error.localizedDescription)))
                return
            }
            
            // Ensure data is available
            guard let data = data else {
                completion(.failure(.network(string: "No data received")))
                return
            }
            
            // Successful data retrieval
            completion(.success(data))
        }
        
        // Start the task
        task.resume()
        return task
    }
}
