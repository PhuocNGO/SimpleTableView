//
//  CommentViewModel.swift
//  SImpleTableView
//
//  Created by Phuoc Ngo on 2/26/20.
//  Copyright © 2020 Phuoc Ngo. All rights reserved.
//

import UIKit

class CommentViewModel: GenericDataSource<CommentModel> {
    var postID: Int {
        didSet { service?.postID = postID }
    }
    var service: CommentService?
    var onErrorHandling : ((ErrorResult?) -> Void)?
    
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
                case .failure(let error):
                    self.onErrorHandling?(error)
                }
            }
        }
    }
    
    func fetchImage(from id: Int, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: "https://i.picsum.photos/id/\(id)/100/100.jpg")
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
        dataTask.resume()
    }
}

extension CommentViewModel : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.reuseIdentifier, for: indexPath) as! ImageViewCell
        let comment = self.data.value[indexPath.row]
        fetchImage(from: comment.id) { (imageData) in
            if let data = imageData {
                // referenced imageView from main thread
                // as iOS SDK warns not to use images from
                // a background thread
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: data)
                }
            } else {
                // show as an alert if you want to
                print("Error loading image");
            }
        }
        return cell
    }
}
