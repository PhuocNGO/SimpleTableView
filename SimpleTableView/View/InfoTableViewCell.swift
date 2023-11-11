//
//  InfoTableViewCell.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

//
//  InfoTableViewCell.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/21/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

/// Custom table view cell for displaying post information.
class InfoTableViewCell: UITableViewCell {
    /// Reuse identifier for the cell.
    static var identifier: String = "InfoTableViewCell_ID"
    
    /// The post ID associated with the cell.
    var id: Int = 0 {
        didSet {
            guard id > 0 else { return }
            self.viewModel.postID = id
            self.viewModel.fetchComments()
        }
    }
    
    /// ViewModel for handling comment data.
    lazy var viewModel: CommentViewModel = { [unowned self] in
        let vm = CommentViewModel(postID: id)
        vm.delegate = self
        return vm
    }()
    
    /// ActivityIndicator to indicate image loading.
    let activityIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView(style: .medium)
    }()
    
    /// ImageView for displaying the post profile image.
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .gray
        return iv
    }()
    
    /// Label for displaying the post title.
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    /// Label for displaying the post body.
    let bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    /// CollectionView for displaying comment images.
    let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.reuseIdentifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .white
        
        return cv
    }()
    
    /// Initializes a new instance of the cell.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
        self.viewModel.data.addObserverAndFire(self) { [weak self] _ in
            self?.collectionView.isHidden = false
            self?.collectionView.reloadData()
        }
    }
    
    /// Initializes a new instance from storyboard or xib.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Prepares the cell for reuse by resetting its state.
    override func prepareForReuse() {
        super.prepareForReuse()
        initData()
    }
    
    /// Resets the initial data for the cell.
    private func initData() {
        profileImageView.image = nil
        titleLabel.text = ""
        bodyLabel.text = ""
        collectionView.isHidden = true
    }
    
    /// Sets the content of the cell with a PostModel.
    ///
    /// - Parameter post: The PostModel to set the content.
    func setContent(_ post: PostModel) {
        id = post.id
        titleLabel.text = post.title
        bodyLabel.text = post.body
    }
    
    /// Configures the cell with an image.
    ///
    /// - Parameter image: The image to be displayed. Pass `nil` to reset the cell.
    func set(image: UIImage?) {
        profileImageView.image = image
        
        if image != nil {
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.startAnimating()
        }
    }
    
    /// Sets up the initial view hierarchy and styling.
    private func setupView() {
        initData()
        let marginGuide = contentView.layoutMarginsGuide
        
        self.selectionStyle = .none
        
        self.contentView.addSubview(profileImageView)
        profileImageView.anchor(top: marginGuide.topAnchor,
                                left: marginGuide.leftAnchor,
                                width: 90,
                                height: 90)
        
        profileImageView.addSubview(activityIndicator)
        activityIndicator.anchor(top: profileImageView.topAnchor,
                                 left: profileImageView.leftAnchor,
                                 bottom: profileImageView.bottomAnchor,
                                 right: profileImageView.rightAnchor)
        
        self.contentView.addSubview(titleLabel)
        titleLabel.anchor(leading: profileImageView.trailingAnchor,
                          trailing: marginGuide.trailingAnchor,
                          top: profileImageView.topAnchor,
                          paddingLeading: 10)
        
        self.contentView.addSubview(bodyLabel)
        bodyLabel.anchor(leading: titleLabel.leadingAnchor,
                         trailing: marginGuide.trailingAnchor,
                         top: titleLabel.bottomAnchor,
                         paddingTop: 10)
        
        self.contentView.addSubview(collectionView)
        collectionView.dataSource = viewModel
        collectionView.prefetchDataSource = viewModel
        collectionView.anchor(leading: marginGuide.leadingAnchor,
                              trailing: marginGuide.trailingAnchor,
                              top: bodyLabel.bottomAnchor,
                              bottom: marginGuide.bottomAnchor,
                              paddingTop: 10,
                              height: 60)
    }
}

/// Extension for InfoTableViewCell implementing the ImageTaskDownloadedDelegate protocol.
extension InfoTableViewCell: ImageTaskDownloadedDelegate {
    /// Handles the event when an image task finishes downloading.
    ///
    /// - Parameter position: The position of the image task.
    func imageTaskDidFinishDownloading(position: Int) {
        self.collectionView.reloadItems(at: [IndexPath(row: position, section: 0)])
    }
}
