//
//  ErrorResult.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/20/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

/// Enum representing different types of errors that can occur in the application.
enum ErrorResult: Error {
    
    /// Error related to network operations.
    case network(string: String)
    
    /// Error related to parsing data.
    case parser(string: String)
    
    /// Custom error with a user-defined message.
    case custom(string: String)
}
