//
//  ImageModel.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

class ImageModel: Decodable {
    
    /// MARK: - Properties
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: URL
    let downloadURL: URL
    
    /// MARK: -  Structures
    private enum CodingKeys: String, CodingKey {
        case id           = "id"
        case author       = "author"
        case width        = "width"
        case height       = "height"
        case url          = "url"
        case downloadURL  = "download_url"
    }
    
    /// MARK: -   Decodable
    required init(from decoder: Decoder) throws {
        do {
            let values  = try decoder.container(keyedBy: CodingKeys.self)
            id          = try values.decode(String.self, forKey: .id)
            author      = try values.decode(String.self, forKey: .author)
            width       = try values.decode(Int.self, forKey: .width)
            height      = try values.decode(Int.self, forKey: .height)
            url         = try values.decode(URL.self, forKey: .url)
            downloadURL = try values.decode(URL.self, forKey: .downloadURL)
        } catch {
            print(error.localizedDescription)
            throw error
        }
    }
}
