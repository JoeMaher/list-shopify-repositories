//
//  Repository.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation
import CoreData

struct Repository: Codable {
    let id: Int
    let name: String
    let fork: Bool
    let stars: Int
    let created: String
    let url: URL

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fork
        case stars = "stargazers_count"
        case created = "created_at"
        case url = "html_url"
    }

    static func from(managedObject object: NSManagedObject) -> Result<Repository> {
        guard let id = object.value(forKey: .id) as? Int,
            let name = object.value(forKey: .name) as? String,
            let fork = object.value(forKey: .fork) as? Bool,
            let stars = object.value(forKey: .stars) as? Int,
            let created = object.value(forKey: .created) as? String,
            let absoluteString = object.value(forKey: .url) as? String,
            let url = URL(string: absoluteString) else { return .failure(RepositoryError.retrieval) }
        return .success(Repository(id: id, name: name, fork: fork, stars: Int(stars), created: created, url: url))
    }
}

enum RepositoryError: LocalizedError {
    case retrieval

    var errorDescription: String? {
        switch self {
        case .retrieval: return "Unable to retrieve repository entity"
        }
    }
}
