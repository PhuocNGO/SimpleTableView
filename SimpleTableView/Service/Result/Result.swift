//
//  Result.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/20/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

/// Represents the result of an API operation.
enum APIResult<Value> {
    
    /// Indicates a successful API operation with an associated value.
    case success(Value)
    
    /// Indicates a failed API operation with an associated error.
    case failure(Error)
}
