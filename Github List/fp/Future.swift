//
//  Future.swift
//  Github List
//
//  Created by Joe Maher on 7/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

class Future<T> {
    public typealias Completion = (T) -> ()
    public typealias Operation = (@escaping Completion) -> ()

    public let operation: Operation
    var result: T?

    public init(operation: @escaping Operation) {
        self.operation = operation
    }

    public convenience init(value: T) {
        self.init { completion in completion(value) }
    }

    public func run(_ completion: @escaping Completion) {
        operation {
            self.result = $0
            completion($0)
        }
    }

    public func get<U>() -> Result<U> where T == Result<U> {
        let semaphore = DispatchSemaphore(value: 0)

        self.run { _ in
            defer {
                semaphore.signal()
            }
        }

        semaphore.wait()

        return Result.wrap(optional: result, or: NSError(domain: "Future failed to complete during join operation", code: 0, userInfo: nil)).flatMap(id)
    }
}

extension Future {
    func map<U>(_ transform: @escaping (T) -> U) -> Future<U> {
        return Future<U> { completion in
            self.operation { v in
                completion(transform(v))
            }
        }
    }

    func flatMap<U>(_ transform: @escaping (T) -> Future<U>) -> Future<U> {
        return Future<U> { completion in
            self.operation { v in
                transform(v).operation(completion)
            }
        }
    }
}
