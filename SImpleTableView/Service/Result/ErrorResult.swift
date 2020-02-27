//
//  ErrorResult.swift
//  SImpleTableView
//
//  Created by Phuoc Ngo on 2/20/20.
//  Copyright © 2020 Phuoc Ngo. All rights reserved.
//

import Foundation

 enum ErrorResult: Error {
     case network(string: String)
     case parser(string: String)
     case custom(string: String)
 }
