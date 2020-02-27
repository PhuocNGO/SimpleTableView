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
    var imageTasks  = [Int: ImageTask]()
    var delegate: ImageTaskDownloadedDelegate?
    
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
                    self.setupImageTasks()
                case .failure(let error):
                    self.onErrorHandling?(error)
                }
            }
        }
    }
    
    private func setupImageTasks() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        for (i, post) in self.data.value.enumerated() {
            let url = URL(string: getImageUrlFor(post: post))!
            let imageTask = ImageTask(position: i, url: url, session: session, delegate: delegate)
            imageTasks[i] = imageTask
        }
    }
    
    internal func getImageUrlFor(post: PostModel) -> String {
        return "https://via.placeholder.com/100x100.png?text=\(post.userID)-\(post.id)"
    }
}

extension PostViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        cell.setContent(data.value[indexPath.row])
        cell.set(image: imageTasks[indexPath.row]?.image)
        imageTasks[indexPath.row]?.resume()
        return cell
    }
}

extension PostViewModel : UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach( { imageTasks[$0.row]?.resume() })
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach( { imageTasks[$0.row]?.pause() })
    }
}
