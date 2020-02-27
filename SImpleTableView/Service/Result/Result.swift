//
//  Result.swift
//  SImpleTableView
//
//  Created by Tommy Ngo on 2/20/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

enum APIResult<Value> {
    case success(Value)
    case failure(Error)
}
