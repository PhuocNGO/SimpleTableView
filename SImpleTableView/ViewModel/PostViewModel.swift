//
//  ViewModel.swift
//  SImpleTableView
//
//  Created by Phuoc Ngo on 2/21/20.
//  Copyright © 2020 Phuoc Ngo. All rights reserved.
//

import UIKit

class PostViewModel: GenericDataSource<PostModel> {
    
    weak var service: PostService?
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
    override init() {
        super.init()
        service = PostService.shared
    }
    
    func fetchPosts() {
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "Missing service"))
            return
        }
        
        service.fetchPost { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self.data.value = posts
                case .failure(let error):
                    self.onErrorHandling?(error)
                }
            }
        }
    }
}

extension PostViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        let post = self.data.value[indexPath.row]
        cell.id = post.id
        cell.titleLabel.text = post.title
        cell.bodyLabel.text = post.body
        return cell
    }
}
