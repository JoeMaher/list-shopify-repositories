//
//  ViewController.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import UIKit
import WebKit

class GithubListTableViewController: UITableViewController, Presentation {

    var interactor: Interactor {
        return Interactor(presenter: Presenter(viewController: self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RepositoryCell", bundle: nil), forCellReuseIdentifier: "repositoryCell")
        interactor.fetchList()
        self.navigationItem.title = "Repositories"
    }

    func reloadData() {
        self.tableView.reloadData()
    }

    func displayError(error: Error) {
        onMainQueueAsync {
            let alert = UIAlertController(title: "An error has occurred", message: "Description: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }

    func displayWebPage(url: URL) {
        let controller = WebViewController()
        controller.webUrl = url
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

extension GithubListTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.listItemCount()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryTableCellView
        interactor.itemFor(indexPath: indexPath).forEach(cell.configure)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.selectedItemAt(indexPath: indexPath)
    }
}
