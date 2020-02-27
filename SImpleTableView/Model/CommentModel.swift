//
//  CommentModel.swift
//  SImpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

final class CommentModel: Decodable {
    
    // MARK: - Properties
    let postID, id: Int
    let name, email, body: String

    // MARK: - Structures
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
    
    // MARK: - Initialize
    init(postID: Int, id: Int, name: String, email: String, body: String) {
        self.postID = postID
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
    
    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        do {
            let values  = try decoder.container(keyedBy: CodingKeys.self)
            self.postID = try values.decode(Int.self,    forKey: .postID)
            self.id     = try values.decode(Int.self,    forKey: .id)
            self.name   = try values.decode(String.self, forKey: .name)
            self.email  = try values.decode(String.self, forKey: .email)
            self.body   = try values.decode(String.self, forKey: .body)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}

// MARK: - Parcelable
extension CommentModel: Parcelable {
    static func parseObject(dictionary: [String : AnyObject]) -> Result<CommentModel, ErrorResult> {
        guard   let postID  = dictionary[CodingKeys.postID.rawValue] as? Int,
                let id      = dictionary[CodingKeys.id.rawValue] as? Int,
                let name    = dictionary[CodingKeys.name.rawValue] as? String,
                let email   = dictionary[CodingKeys.email.rawValue] as? String,
                let body    = dictionary[CodingKeys.body.rawValue] as? String
        else {
            return Result.failure(ErrorResult.parser(string: "Unable to parse post model"))
        }
        let comment = CommentModel(postID: postID, id: id, name: name, email: email, body: body)
        return Result.success(comment)
    }
}
