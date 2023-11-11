//
//  ViewModel.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

/// View model for handling post data and image tasks.
class PostViewModel: GenericDataSource<PostModel> {
    
    // MARK: - Properties
    
    weak var service: PostService?
    var onErrorHandling: ((ErrorResult?) -> Void)?
    var imageTasks = [Int: ImageTask]()
    var delegate: ImageTaskDownloadedDelegate?
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        service = PostService.shared
    }
    
    // MARK: - Public Methods
    
    /// Fetch all posts from the server.
    func fetchPosts() {
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "Missing service"))
            return
        }
        
        service.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.data.value = posts
                    self?.setupImageTasks()
                case .failure(let error):
                    self?.onErrorHandling?(error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Set up image tasks for downloading images from image URLs.
    private func setupImageTasks() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        for (i, post) in self.data.value.enumerated() {
            let url = URL(string: getImageUrlFor(post: post))!
            let imageTask = ImageTask(position: i, url: url, session: session, delegate: delegate)
            imageTasks[i] = imageTask
        }
    }
    
    /// Get the URL template for post images.
    internal func getImageUrlFor(post: PostModel) -> String {
        return "https://picsum.photos/id/\(post.id)/200/200.jpg"
    }
}

// MARK: - UITableViewDataSource Extension

extension PostViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoTableViewCell.identifier, for: indexPath) as! InfoTableViewCell
        cell.setContent(data.value[indexPath.row])
        cell.set(image: imageTasks[indexPath.row]?.image)
        
        // Start downloading image with ImageTask.
        imageTasks[indexPath.row]?.resume()
        return cell
    }
}

// MARK: - UITableViewDataSourcePrefetching Extension

extension PostViewModel: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { imageTasks[$0.row]?.resume() }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { imageTasks[$0.row]?.pause() }
    }
}

