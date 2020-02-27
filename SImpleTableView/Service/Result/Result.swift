//
//  Result.swift
//  SImpleTableView
//
//  Created by Phuoc Ngo on 2/20/20.
//  Copyright © 2020 Phuoc Ngo. All rights reserved.
//

import Foundation

enum APIResult<Value> {
    case success(Value)
    case failure(Error)
}
