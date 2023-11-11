//
//  ParcerHelper.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

// MARK: - Parcelable Protocol

protocol Parcelable {
    static func parseObject(dictionary: [String: AnyObject]) -> Result<Self, ErrorResult>
}

final class ParserHelper {
    
    // MARK: Single Object Parsing
        
    /// Parse a single object from JSON data.
    ///
    /// - Parameters:
    ///   - data: The JSON data to parse.
    ///   - completion: A closure to be called with the result of the parsing.
    
    static func parse<T: Parcelable>(data: Data, completion: (Result<T, ErrorResult>) -> Void) {
        do {
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject] else {
                completion(.failure(.parser(string: "Json data is not a dictionary")))
                return
            }
            
            switch T.parseObject(dictionary: dictionary) {
            case .failure(let error):
                completion(.failure(error))
                break
            case .success(let model):
                completion(.success(model))
                break
            }
        } catch {
            // can't parse json
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }
    
    // MARK: Array of Objects Parsing
    
    /// Parse an array of objects from JSON data.
    ///
    /// - Parameters:
    ///   - data: The JSON data to parse.
    ///   - completion: A closure to be called with the result of the parsing.
    
    static func parse<T: Parcelable>(data: Data, completion: (Result<[T], ErrorResult>) -> Void) {
        do {
            guard let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [AnyObject]  else {
                completion(.failure(.parser(string: "Json data is not an array")))
                return
            }
            
            var finalResult : [T] = []
            for object in result {
                guard let dictionary = object as? [String : AnyObject]  else {
                    continue
                }
                
                handleParsedObject(T.self, from: dictionary) { result in
                    switch result {
                    case .success(let newModel):
                        finalResult.append(newModel)
                    case .failure:
                        break
                    }
                }
            }
            completion(.success(finalResult))
        } catch {
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }
    
    // MARK: Private Helper Method
        
    /// Handles parsing of an individual object.
    ///
    /// - Parameters:
    ///   - type: The type of the object to parse.
    ///   - dictionary: The dictionary containing the object data.
    ///   - completion: A closure to be called with the result of the parsing.
    
    private static func handleParsedObject<T: Parcelable>(_ type: T.Type, from dictionary: [String: AnyObject], completion: @escaping (Result<T, ErrorResult>) -> Void) {
        switch T.parseObject(dictionary: dictionary) {
        case .failure(let error):
            completion(.failure(error))
        case .success(let model):
            completion(.success(model))
        }
    }
}
