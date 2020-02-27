//
//  APIService.swift
//  SImpleTableView
//
//  Created by Tommy Ngo on 2/26/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation

final class PostService: RequestHandler {
    static let shared = PostService()
    var task : URLSessionTask?
    
    func fetchPost(_ completion: @escaping ((Result<[PostModel], ErrorResult>) -> Void)) {
        self.cancelFetchPosts()
        let endpoint = RequestService.baseURL + "/posts"
        task = RequestService().loadData(urlString: endpoint, completion: self.networkResult(completion: completion))
    }

    func cancelFetchPosts() {
        task?.cancel()
        task = nil
    }
}
