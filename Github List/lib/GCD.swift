//
//  GCD.swift
//  Github List
//
//  Created by Joe Maher on 8/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

public func onMainQueueAsync(_ closure:@escaping ()->()) {
    DispatchQueue.main.async(execute: closure)
}

public func onGlobalQueueAsync(_ closure:@escaping ()->()) {
    DispatchQueue.global(qos: .default).async(execute: closure)
}
