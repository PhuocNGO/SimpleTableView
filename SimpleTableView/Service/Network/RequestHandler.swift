//
//  RequestHandler.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

class RequestHandler {
    
    // MARK: - Network Result Handling
    
    /// Handles network result for an array of objects.
    ///
    /// - Parameter completion: A closure to be called with the result of the parsing.
    /// - Returns: A closure to handle the result of a network operation.
    func networkResult<T: Parcelable>(completion: @escaping (Result<[T], ErrorResult>) -> Void) -> (Result<Data, ErrorResult>) -> Void {
        return { dataResult in
            DispatchQueue.global(qos: .background).async {
                switch dataResult {
                case .success(let data):
                    ParserHelper.parse(data: data, completion: completion)
                case .failure(let error):
                    print("Network error: \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                }
            }
        }
    }
    
    /// Handles network result for a single object.
    ///
    /// - Parameter completion: A closure to be called with the result of the parsing.
    /// - Returns: A closure to handle the result of a network operation.
    func networkResult<T: Parcelable>(completion: @escaping (Result<T, ErrorResult>) -> Void) -> (Result<Data, ErrorResult>) -> Void {
        return { dataResult in
            DispatchQueue.global(qos: .background).async {
                switch dataResult {
                case .success(let data):
                    ParserHelper.parse(data: data, completion: completion)
                case .failure(let error):
                    print("Network error: \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                }
            }
        }
    }
}

