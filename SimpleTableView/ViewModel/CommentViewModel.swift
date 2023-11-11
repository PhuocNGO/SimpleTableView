//
//  CommentViewModel.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/26/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

/// ViewModel for handling comments and associated image tasks.
class CommentViewModel: GenericDataSource<CommentModel> {
    
    // MARK: - Properties
    
    var postID: Int {
        didSet { service?.postID = postID }
    }
    var service: CommentService?
    var onErrorHandling: ((ErrorResult?) -> Void)?
    var delegate: ImageTaskDownloadedDelegate?
    
    var imageTasks = [Int: ImageTask]()
    private let session: URLSession
    
    // MARK: - Initialization
    
    init(postID: Int, session: URLSession = URLSession(configuration: .default)) {
        self.postID = postID
        self.service = CommentService(postID: postID)
        self.session = session
        super.init()
    }
    
    // MARK: - Public Methods
    
    /// Fetch comments associated with the post.
    func fetchComments() {
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "Missing service"))
            return
        }
        
        service.fetchComments { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self?.data.value = comments
                    self?.setupImageTasks()
                case .failure(let error):
                    self?.data.value = []
                    self?.onErrorHandling?(error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Set up image tasks for downloading images from image URLs.
    private func setupImageTasks() {
        for (index, comment) in self.data.value.enumerated() {
            if let url = URL(string: getImageUrlFor(id: comment.id)) {
                let imageTask = ImageTask(position: index, url: url, session: session, delegate: delegate)
                imageTasks[index] = imageTask
                imageTask.resume()
            }
        }
    }
    
    /// Get the URL template for comment images.
    internal func getImageUrlFor(id: Int) -> String {
        return "https://picsum.photos/id/\(id)/100/100.jpg"
    }
}

// MARK: - UICollectionViewDataSource Extension

extension CommentViewModel: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.reuseIdentifier, for: indexPath) as! ImageViewCell
        cell.configure(with: imageTasks[indexPath.row]?.image)
        return cell
    }
}

// MARK: - UICollectionViewDataSourcePrefetching Extension

extension CommentViewModel: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { imageTasks[$0.row]?.resume() }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { imageTasks[$0.row]?.pause() }
    }
}

