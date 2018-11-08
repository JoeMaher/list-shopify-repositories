//
//  Presenter.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

protocol Presentation {
    func reloadData()
    func displayError(error: Error)
    func displayWebPage(url: URL)
}

class Presenter {
    let viewController: Presentation

    init(viewController: Presentation) {
        self.viewController = viewController
    }

    func reloadData() {
        self.viewController.reloadData()
    }

    func displayError(_ error: Error) {
        self.viewController.displayError(error: error)
    }

    func displayWebPage(_ url: URL) {
        self.viewController.displayWebPage(url: url)
    }
}
