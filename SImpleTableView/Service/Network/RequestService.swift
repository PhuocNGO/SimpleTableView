//
//  RequestService.swift
//  SImpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

final class RequestService {
    static let baseURL = "https://jsonplaceholder.typicode.com"
    
    func loadData(urlString: String, session: URLSession = URLSession(configuration: .default),
                  completion: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask? {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return nil
        }
        
        let request = RequestFactory.request(method: .GET, url: url)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(string: "Getting this error during load data: " + error.localizedDescription)))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
        return nil
    }
}
