//
//  Interactor.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

class Interactor {
    let presenter: Presenter
    let network: Network = Network()
    let storage: Storage = Storage()

    init(presenter: Presenter) {
        self.presenter = presenter
    }

    func fetchList() {
        onGlobalQueueAsync {
            self.network.fetchList().reduce(failure: self.presenter.displayError, success: self.handleFetch)
        }
    }

    func handleFetch(_ repos: [Repository]) {
        onMainQueueAsync {
            switch self.storage.storeRepositories(repos) {
            case .failure(let error):
                self.presenter.displayError(error)
            case .success:
                self.presenter.reloadData()
            }
        }
    }

    func listItemCount() -> Int {
        switch storage.getRepositories() {
        case .failure(let error):
            presenter.displayError(error)
            return 0
        case .success(let repos):
            return repos.count
        }
    }

    func itemFor(indexPath: IndexPath) -> Repository? {
        guard let repos = storage.getRepositories().value else { return nil}
        return repos[indexPath.row]
    }

    func selectedItemAt(indexPath: IndexPath){
        guard let repos = storage.getRepositories().value else { return }
        presenter.displayWebPage(repos[indexPath.row].url)
    }
}
