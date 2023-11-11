//
//  ViewController.swift
//  SimpleTableView
//
//  Created by Tommy Ngo on 2/19/20.
//  Copyright © 2020 Ngo. All rights reserved.
//

import UIKit

/// The main view controller responsible for displaying a list of posts.
class ViewController: UIViewController {
    /// Weak reference to the table view.
    weak var tableView: UITableView!

    /// The view model for managing post data.
    lazy var viewModel: PostViewModel = { [unowned self] in
        let vm = PostViewModel()
        vm.delegate = self
        return vm
    }()

    /// Overrides the loadView method to create and set up the table view.
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

    /// Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cell class for reuse.
        self.tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.identifier)
        
        // Set up table view properties.
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = viewModel
        self.tableView.prefetchDataSource = viewModel
        
        // Observe changes in the data and reload the table view accordingly.
        self.viewModel.data.addObserverAndFire(self) { [weak self] _ in
            self?.tableView.reloadData()
        }
        
        // Set up error handling for the view model.
        self.viewModel.onErrorHandling = { [weak self] error in
            // Display an alert controller for error handling.
            let controller = UIAlertController(title: "An error occurred", message: "Oops, something went wrong!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self?.present(controller, animated: true, completion: nil)
        }
        
        // Fetch posts using the view model.
        self.viewModel.fetchPosts()
    }
}

/// Extension for ViewController implementing the ImageTaskDownloadedDelegate protocol.
extension ViewController: ImageTaskDownloadedDelegate {
    /// Delegate function called after download image is done.
    ///
    /// - Parameter position: The position of the image task.
    func imageTaskDidFinishDownloading(position: Int) {
        let indexPath = IndexPath(row: position, section: 0)
        
        // Only reload cells that are currently visible.
        if tableView.indexPathsForVisibleRows?.contains(indexPath) == true {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

