//
//  APIService.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/26/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

/// Service class for handling post-related API requests.
final class PostService: RequestHandler {
    
    /// Shared instance of PostService.
    static let shared = PostService()
    /// The URLSessionTask responsible for the ongoing data fetch operation.
    var task: URLSessionTask?

    /// Fetches posts from the API.
    ///
    /// - Parameter completion: A closure to be called with the result of the fetch operation.
    func fetchPosts(completion: @escaping (Result<[PostModel], ErrorResult>) -> Void) {
        // Cancel any ongoing fetch operation before starting a new one
        cancelFetchPosts()

        // Construct the API endpoint for fetching posts
        let endpoint = RequestService.baseURL + "/posts"
        
        // Load data from the API and handle the result using the networkResult closure
        task = RequestService().loadData(urlString: endpoint, completion: networkResult(completion: completion))
    }

    /// Cancels the ongoing fetch operation for posts.
    func cancelFetchPosts() {
        // Cancel the URLSessionTask if it's currently active
        task?.cancel()
        task = nil
    }
}

