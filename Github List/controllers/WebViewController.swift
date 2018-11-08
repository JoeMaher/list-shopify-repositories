//
//  WebViewController.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    var webUrl: URL!

    override func viewDidLoad() {
        view.backgroundColor = .white
    }

    override func viewDidAppear(_ animated: Bool) {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        webView.load(URLRequest(url: webUrl))
        self.view.addSubview(webView)
    }

}
