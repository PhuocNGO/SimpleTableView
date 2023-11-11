//
//  ImageModel.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

/// A model representing an image, conforming to the Decodable protocol.
class ImageModel: Decodable {
    
    // MARK: - Properties
    
    /// The unique identifier of the image.
    let id: String
    
    /// The author or creator of the image.
    let author: String
    
    /// The width of the image.
    let width: Int
    
    /// The height of the image.
    let height: Int
    
    /// The URL of the image.
    let url: URL
    
    /// The download URL of the image.
    let downloadURL: URL
    
    // MARK: - Coding Keys
    
    /// Enumeration to define the coding keys for decoding.
    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case downloadURL = "download_url"
    }
    
    // MARK: - Decodable
    
    /// Initializes an instance of ImageModel by decoding from a decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if the decoding fails.
    required init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            author = try values.decode(String.self, forKey: .author)
            width = try values.decode(Int.self, forKey: .width)
            height = try values.decode(Int.self, forKey: .height)
            url = try values.decode(URL.self, forKey: .url)
            downloadURL = try values.decode(URL.self, forKey: .downloadURL)
        } catch {
            // Print and rethrow the error for debugging purposes
            print(error.localizedDescription)
            throw error
        }
    }
}

