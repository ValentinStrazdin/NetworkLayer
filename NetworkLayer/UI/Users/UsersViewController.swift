//
//  UsersViewController.swift
//  NetworkLayer
//
//  Created by Valentin Strazdin on 1/30/22.
//

import UIKit
import Reusable

class UsersViewController: UITableViewController {
    var viewModel: UsersViewModel = UsersViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: UserCell.self)
        reloadData()
    }

    @IBAction func refreshAction(_ sender: UIRefreshControl) {
        reloadData()
    }

    func reloadData() {
        viewModel.getUsers { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                switch result {
                case .success:
                    self?.tableView.reloadData()
                case .failure(let error):
                    self?.showError(error.description) {
                        self?.tableView.reloadData()
                    }
                }
            }
        }
    }

    private func showError(_ message: String?, completion: VoidBlock? = nil) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            completion?()
        })
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCell(for: indexPath)
        cell.user = viewModel.users[indexPath.row]
        return cell
    }
}

