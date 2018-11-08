//
//  RespositoryTableCellView.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation
import UIKit

class RepositoryTableCellView: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    @IBOutlet weak var forkImageView: UIImageView!

    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter
    }

    func configure(_ repo: Repository) {
        self.nameLabel.text = repo.name
        self.createdLabel.text = formatDate(repo.created)
        self.starCountLabel.text = String(repo.stars)
        self.forkImageView.isHidden = !repo.fork
    }

    func formatDate(_ stamp: String) -> String {
        guard let date = dateFormatter.date(from: stamp) else { return "N/A" }
        let daysAgo = Int(date.timeIntervalSinceNow) * -1 / (60 * 60 * 24)
        return "Created \(daysAgo) days ago"
    }
}
