//
//  CommentService.swift
//  SImpleTableView
//
//  Created by Phuoc Ngo on 2/26/20.
//  Copyright © 2020 Phuoc Ngo. All rights reserved.
//

import Foundation

final class CommentService: RequestHandler {
    var postID: Int
    var task : URLSessionTask?
    
    init(_ postID: Int) {
        self.postID = postID
    }
    
    func fetchComments(_ completion: @escaping ((Result<[CommentModel], ErrorResult>) -> Void)) {
        self.cancelFetchPosts()
        let endpoint = "\(RequestService.baseURL)/posts/\(postID)/comments"
        task = RequestService().loadData(urlString: endpoint, completion: self.networkResult(completion: completion))
    }

    func cancelFetchPosts() {
        task?.cancel()
        task = nil
    }
}
