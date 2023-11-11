//
//  PostModel.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

/// A model representing a post, conforming to the Decodable protocol.
final class PostModel: Decodable {
    
    // MARK: - Properties
    
    /// The user ID associated with the post.
    let userID: Int
    
    /// The unique identifier of the post.
    let id: Int
    
    /// The title of the post.
    let title: String
    
    /// The body or content of the post.
    let body: String
    
    // MARK: - Coding Keys
    
    /// Enumeration to define the coding keys for decoding.
    private enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
    
    // MARK: - Initialization
    
    /// Initializes a new instance of PostModel with specified values.
    ///
    /// - Parameters:
    ///   - userID: The user ID associated with the post.
    ///   - id: The unique identifier of the post.
    ///   - title: The title of the post.
    ///   - body: The body or content of the post.
    init(userID: Int, id: Int, title: String, body: String) {
        self.userID = userID
        self.id = id
        self.title = title
        self.body = body
    }
    
    // MARK: - Decodable
    
    /// Initializes an instance of PostModel by decoding from a decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if the decoding fails.
    required init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(Int.self, forKey: .id)
            userID = try values.decode(Int.self, forKey: .userID)
            title = try values.decode(String.self, forKey: .title)
            body = try values.decode(String.self, forKey: .body)
        } catch {
            // Print and rethrow the error for debugging purposes
            print(error.localizedDescription)
            throw error
        }
    }
}

// MARK: - Parcelable Extension

extension PostModel: Parcelable {
    /// Parses a dictionary into a PostModel object.
    ///
    /// - Parameter dictionary: The dictionary to parse.
    /// - Returns: A Result containing either the parsed PostModel or an error.
    static func parseObject(dictionary: [String: AnyObject]) -> Result<PostModel, ErrorResult> {
        guard
            let id = dictionary[CodingKeys.id.rawValue] as? Int,
            let userID = dictionary[CodingKeys.userID.rawValue] as? Int,
            let title = dictionary[CodingKeys.title.rawValue] as? String,
            let body = dictionary[CodingKeys.body.rawValue] as? String
        else {
            return .failure(ErrorResult.parser(string: "Unable to parse post model"))
        }
        let post = PostModel(userID: userID, id: id, title: title, body: body)
        return .success(post)
    }
}

