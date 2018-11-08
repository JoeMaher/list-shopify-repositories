//
//  Network.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

class Network {
    let api = GithubAPI()

    func fetchList() -> Result<[Repository]> {
       return api.fetchList("shopify")
    }
}
