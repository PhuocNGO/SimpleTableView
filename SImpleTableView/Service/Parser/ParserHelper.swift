//
//  ParcerHelper.swift
//  SImpleTableView
//
//  Created by Phuoc Ngo on 2/21/20.
//  Copyright © 2020 Phuoc Ngo. All rights reserved.
//

import Foundation

protocol Parcelable {
    static func parseObject(dictionary: [String: AnyObject]) -> Result<Self, ErrorResult>
}

final class ParserHelper {
    
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
                
                switch T.parseObject(dictionary: dictionary) {
                case .failure(_):
                    continue
                case .success(let newModel):
                    finalResult.append(newModel)
                    break
                }
            }
            completion(.success(finalResult))
        } catch {
            // can't parse json
            completion(.failure(.parser(string: "Error while parsing json data")))
        }
    }
}
