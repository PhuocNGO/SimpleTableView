//
//  ImageViewCell.swift
//  SImpleTableView
//
//  Created by Tommy Ngo on 2/26/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell {
    static var reuseIdentifier: String = "ImageViewCell"
    
    let activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(style: .medium)
    }()
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        set(image: nil)
    }
    
    func set(image: UIImage?) {
        imageView.image = image
        
        if image == nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupView() {
        backgroundColor = UIColor.lightGray
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        clipsToBounds = true
        
        self.addSubview(imageView)
        imageView.anchor(top: topAnchor,
                         left: leftAnchor,
                         bottom: bottomAnchor,
                         right: rightAnchor)
        
        self.addSubview(activityIndicator)
        activityIndicator.anchor(top: topAnchor,
                                 left: leftAnchor,
                                 bottom: bottomAnchor,
                                 right: rightAnchor)
    }
}
