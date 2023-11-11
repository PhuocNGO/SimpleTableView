//
//  CommentModel.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

/// A model representing a comment, conforming to the Decodable protocol.
final class CommentModel: Decodable {
    
    // MARK: - Properties
    
    /// The ID of the post associated with the comment.
    let postID: Int
    
    /// The unique identifier of the comment.
    let id: Int
    
    /// The name of the commenter.
    let name: String
    
    /// The email address of the commenter.
    let email: String
    
    /// The body or content of the comment.
    let body: String

    // MARK: - Coding Keys
    
    /// Enumeration to define the coding keys for decoding.
    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
    
    // MARK: - Initialization
    
    /// Initializes a new instance of CommentModel with specified values.
    ///
    /// - Parameters:
    ///   - postID: The ID of the post associated with the comment.
    ///   - id: The unique identifier of the comment.
    ///   - name: The name of the commenter.
    ///   - email: The email address of the commenter.
    ///   - body: The body or content of the comment.
    init(postID: Int, id: Int, name: String, email: String, body: String) {
        self.postID = postID
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
    
    // MARK: - Decodable
    
    /// Initializes an instance of CommentModel by decoding from a decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if the decoding fails.
    required init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            postID = try values.decode(Int.self, forKey: .postID)
            id = try values.decode(Int.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            email = try values.decode(String.self, forKey: .email)
            body = try values.decode(String.self, forKey: .body)
        } catch {
            // Print and rethrow the error for debugging purposes
            print(error.localizedDescription)
            throw error
        }
    }
}

// MARK: - Parcelable Extension

extension CommentModel: Parcelable {
    /// Parses a dictionary into a CommentModel object.
    ///
    /// - Parameter dictionary: The dictionary to parse.
    /// - Returns: A Result containing either the parsed CommentModel or an error.
    static func parseObject(dictionary: [String: AnyObject]) -> Result<CommentModel, ErrorResult> {
        guard
            let postID = dictionary[CodingKeys.postID.rawValue] as? Int,
            let id = dictionary[CodingKeys.id.rawValue] as? Int,
            let name = dictionary[CodingKeys.name.rawValue] as? String,
            let email = dictionary[CodingKeys.email.rawValue] as? String,
            let body = dictionary[CodingKeys.body.rawValue] as? String
        else {
            return .failure(ErrorResult.parser(string: "Unable to parse comment model"))
        }
        let comment = CommentModel(postID: postID, id: id, name: name, email: email, body: body)
        return .success(comment)
    }
}

