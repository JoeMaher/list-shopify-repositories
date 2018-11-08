//
//  Github.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation
import Alamofire

struct GithubAPI {

    enum Endpoint {
        case orgRepos(name: String)

        var host: String {
            return "https://api.github.com"
        }

        func url(_ page: Int = 1) -> String {
            switch self {
            case .orgRepos(let n): return "\(host)/orgs/\(n)/repos?page=\(page)&per_page=100"
            }
        }
    }

    func fetchList(_ orgName: String) -> Result<[Repository]> {
        var repos: [Repository] = []
        var error: Error? = nil
        var page: Int? = 1

        while page != nil {

            fetchPage(.orgRepos(name: orgName), page!).get().reduce(
                failure: {
                    error = $0
                    page = nil
            },
                success: { (arg) in
                    let (repoList, nextPage) = arg
                    repos += repoList
                    page = nextPage
            })
        }

        guard error == nil else { return .failure(error!) }
        return .success(repos)
    }

    func fetchPage(_ endpoint: Endpoint, _ page: Int) -> Future<Result<([Repository], Int?)>> {
        return Future { completion in
            Alamofire.request(endpoint.url(page)).validate().responseData(queue: OperationQueue.current?.underlyingQueue) { response in
                let pagination = response.response?.allHeaderFields["Link"] as? String ?? ""
                switch response.result {
                case .success(let a):
                    completion(self.decode(a).map { self.nextPage($0, page, pagination) })
                case .failure(let b): completion(.failure(b))
                }
            }
        }
    }

    func nextPage(_ repos: [Repository], _ currentPage: Int, _ pagination: String) -> ([Repository], Int?) {
        let next = pagination.contains("last") ? currentPage + 1 : nil
        return (repos, next)
    }

    func decode<T: Codable>(_ data: Data) -> Result<T> {
        let decoder = JSONDecoder()
        return .wrap { try decoder.decode(T.self, from: data) }
    }
}

enum GithubError: LocalizedError {
    case unexpectedResponseType
}
