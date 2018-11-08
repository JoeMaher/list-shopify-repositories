//
//  helpers.swift
//  Github List
//
//  Created by Joe Maher on 7/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

public func id<A>(a: A) -> A {
    return a
}

public func const<A, B>(_ a: A) -> (B) -> A {
    return { _ in a }
}
