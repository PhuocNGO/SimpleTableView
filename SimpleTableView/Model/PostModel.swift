//
//  PostModel.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

final class PostModel: Decodable {
    
    /// MARK: - Properties
    let userID, id: Int
    let title, body: String
    
    /// MARK: - Structures
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
    
    /// MARK: Initialize
    init(userID: Int, id: Int, title: String, body: String) {
        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
    }
    
    /// MARK: - Decodable
    required init(from decoder: Decoder) throws {
        do {
            let values  = try decoder.container(keyedBy: CodingKeys.self)
            self.id     = try values.decode(Int.self, forKey: .id)
            self.userID = try values.decode(Int.self, forKey: .userID)
            self.title  = try values.decode(String.self, forKey: .title)
            self.body   = try values.decode(String.self, forKey: .body)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

extension PostModel: Parcelable {
    static func parseObject(dictionary: [String : AnyObject]) -> Result<PostModel, ErrorResult> {
        guard   let id = dictionary[CodingKeys.id.rawValue] as? Int,
                let userID = dictionary[CodingKeys.userID.rawValue] as? Int,
                let title = dictionary[CodingKeys.title.rawValue] as? String,
                let body = dictionary[CodingKeys.body.rawValue] as? String
        else {
            return Result.failure(ErrorResult.parser(string: "Unable to parse post model"))
        }
        let post = PostModel(userID: userID, id: id, title: title, body: body)
        return Result.success(post)
    }
}
