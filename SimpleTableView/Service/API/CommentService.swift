//
//  CommentService.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/26/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

/// Service class for handling comments related to posts.
final class CommentService: RequestHandler {
    
    /// The ID of the post for which comments are being fetched.
    var postID: Int
    /// The URLSessionTask responsible for the ongoing data fetch operation.
    var task: URLSessionTask?

    /// Initializes a new instance of CommentService with a specified post ID.
    ///
    /// - Parameters 
    ///     - postID: The ID of the post for which comments will be fetched.
    init(postID: Int) {
        self.postID = postID
    }
    
    /// Fetches comments for a specific post.
    ///
    /// - Parameter completion: A closure to be called with the result of the fetch operation.
    func fetchComments(completion: @escaping (Result<[CommentModel], ErrorResult>) -> Void) {
        // Cancel any ongoing fetch operation before starting a new one
        cancelFetchComments()

        // Construct the API endpoint for fetching comments
        let endpoint = "\(RequestService.baseURL)/posts/\(postID)/comments"
        
        // Load data from the API and handle the result using the networkResult closure
        task = RequestService().loadData(urlString: endpoint, completion: networkResult(completion: completion))
    }

    /// Cancels the ongoing fetch operation for comments.
    func cancelFetchComments() {
        // Cancel the URLSessionTask if it's currently active
        task?.cancel()
        task = nil
    }
}
