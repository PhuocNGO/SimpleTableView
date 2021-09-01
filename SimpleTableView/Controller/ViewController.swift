//
//  ViewController.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/19/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    weak var tableView: UITableView!
    
    lazy var viewModel: PostViewModel = { [unowned self] in
        let vm = PostViewModel()
        vm.delegate = self
        return vm
    }()
    
    override func loadView() {
        super.loadView()
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: tableView.topAnchor),
            self.view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            self.view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
        self.tableView = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifier)
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = viewModel
        self.tableView.prefetchDataSource = viewModel
        self.viewModel.data.addObserverAndFire(self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        /// add error handling example
        self.viewModel.onErrorHandling = { [weak self] error in
            /// display error ?
            let controller = UIAlertController(title: "An error occured", message: "Oops, something went wrong!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self?.present(controller, animated: true, completion: nil)
        }
        self.viewModel.fetchPosts()
    }
}

extension ViewController : ImageTaskDownloadedDelegate {
    
    /// Delegate function which would be called after
    /// download image was done.
    func imageDownloaded(position: Int) {
        let indexPath = IndexPath(row: position, section: 0)
        
        /// Only reload cells is visible.
        if tableView.indexPathsForVisibleRows?.contains(indexPath) == true {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}
