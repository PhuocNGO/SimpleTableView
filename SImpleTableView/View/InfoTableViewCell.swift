//
//  InfoTableViewCell.swift
//  SImpleTableView
//
//  Created by Phuoc Ngo on 2/21/20.
//  Copyright © 2020 Phuoc Ngo. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {
    static var identifier: String = "InfoTableViewCell_ID"
    var id: Int = 0 {
        didSet {
            if id > 0 {
                self.viewModel.postID = id
                self.viewModel.fetchComments()
            }
        }
    }
    lazy var viewModel: CommentViewModel = { [unowned self] in
        return CommentViewModel(id)
    }()
    
    
    let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .red
        return iv
    }()
    
    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let bodyLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = .boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let collectionView : UICollectionView = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        
        self.viewModel.data.addObserverAndFire(self) { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        initData()
    }
    
    private func initData() {
        profileImageView.image = nil
        titleLabel.text = ""
        bodyLabel.text = ""
        viewModel.data.value = []
    }
    
    private func setupView() {
        initData()
        
        let marginGuide = contentView.layoutMarginsGuide
        
        self.contentView.addSubview(profileImageView)
        profileImageView.anchor(top: marginGuide.topAnchor,
                                left: marginGuide.leftAnchor,
                                width: 90,
                                height: 90)

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
        collectionView.anchor(leading: marginGuide.leadingAnchor,
                              trailing: marginGuide.trailingAnchor,
                              top: bodyLabel.bottomAnchor,
                              bottom: marginGuide.bottomAnchor,
                              paddingTop: 10,
                              height: 60)
    }
}
