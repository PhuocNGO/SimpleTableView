//
//  CommentViewModel.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/26/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

class CommentViewModel: GenericDataSource<CommentModel> {
    
    var postID: Int {
        didSet { service?.postID = postID }
    }
    var service: CommentService?
    var onErrorHandling : ((ErrorResult?) -> Void)?
    var delegate: ImageTaskDownloadedDelegate?
    
    var imageTasks  = [Int: ImageTask]()
    
    init(_ postID: Int) {
        self.postID = postID
        self.service = CommentService(postID)
        super.init()
    }
    
    func fetchComments() {
        guard let service = service else {
            onErrorHandling?(ErrorResult.custom(string: "Missing service"))
            return
        }
        
        service.fetchComments { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let comments):
                    self.data.value = comments
                    self.setupImageTasks()
                case .failure(let error):
                    self.data.value = []
                    self.onErrorHandling?(error)
                }
            }
        }
    }
    
    /// Set up image task for downloading
    /// image from image url.
    private func setupImageTasks() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        for (i, comment) in self.data.value.enumerated() {
            let url = URL(string: getImageUrlFor(id: comment.id))!
            let imageTask = ImageTask(position: i, url: url, session: session, delegate: delegate)
            imageTasks[i] = imageTask
        }
    }
    
    /// Get the url template for comment images.
    internal func getImageUrlFor(id: Int) -> String {
        return "https://i.picsum.photos/id/\(id)/100/100.jpg"
    }
}

extension CommentViewModel : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.reuseIdentifier, for: indexPath) as! ImageViewCell
        imageTasks[indexPath.row]?.resume()
        cell.set(image: imageTasks[indexPath.row]?.image)
        return cell
    }
}

extension CommentViewModel : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach( { imageTasks[$0.row]?.resume() })
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach( { imageTasks[$0.row]?.pause() })
    }
}
