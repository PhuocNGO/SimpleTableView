//
//  ImageViewCell.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/26/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

/// Custom UICollectionViewCell for displaying images.
class ImageViewCell: UICollectionViewCell {
    /// Reuse identifier for the cell.
    static let reuseIdentifier = "ImageViewCell"

    /// ImageView to display the image.
    private lazy var imageImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    /// ActivityIndicator to indicate image loading.
    private lazy var imageActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    /// Initializes a new instance of the cell.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    /// Initializes a new instance from storyboard or xib.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Prepares the cell for reuse by resetting its state.
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }

    /// Configures the cell with an image.
    ///
    /// - Parameter image: The image to be displayed. Pass `nil` to reset the cell.
    func configure(with image: UIImage?) {
        imageImageView.image = image
        image == nil ? imageActivityIndicator.startAnimating() : imageActivityIndicator.stopAnimating()
    }

    /// Sets up the initial view hierarchy and styling.
    private func setupView() {
        backgroundColor = .lightGray
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4
        clipsToBounds = true

        addSubview(imageImageView)
        imageImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)

        addSubview(imageActivityIndicator)
        imageActivityIndicator.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
}

extension UIView {
    /// Anchors the view within its superview.
    ///
    /// - Parameters:
    ///   - top: The top anchor. Pass `nil` if not needed.
    ///   - left: The left anchor. Pass `nil` if not needed.
    ///   - bottom: The bottom anchor. Pass `nil` if not needed.
    ///   - right: The right anchor. Pass `nil` if not needed.
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top {
            topAnchor.constraint(equalTo: top).isActive = true
        }
        if let left {
            leftAnchor.constraint(equalTo: left).isActive = true
        }
        if let bottom {
            bottomAnchor.constraint(equalTo: bottom).isActive = true
        }
        if let right {
            rightAnchor.constraint(equalTo: right).isActive = true
        }
    }
}


