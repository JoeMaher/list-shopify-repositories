//
//  Result.swift
//  Github List
//
//  Created by Joe Maher on 7/11/18.
//  Copyright © 2018 Personal. All rights reserved.
//

import Foundation

enum Result<T> {
    case failure(Error)
    case success(T)

    public static func wrap(optional: T?, or error: Error) -> Result<T> {
        if let v = optional {
            return .success(v)
        } else {
            return .failure(error)
        }
    }

    public static func wrap(try f: () throws -> T) -> Result<T> {
        do {
            return .success(try f())
        } catch {
            return .failure(error)
        }
    }

    public func reduce<A>(failure: (Error) -> A, success: (T) -> A) -> A {
        switch self {
        case .success(let val): return success(val)
        case .failure(let err): return failure(err)
        }
    }

    public var value: T? {
        return reduce(failure: const(nil), success: id)
    }

}

extension Result {
    func map<U>(_ transform: (T) -> U) -> Result<U> {
        switch self {
        case .success(let t): return .success(transform(t))
        case .failure(let e): return .failure(e)
        }
    }

    func map<U, V>(_ transform: (V) -> (U)) -> Result<[U]> where T == [V] {
        return self.map { a in
            a.map(transform)
        }
    }

    func flatMap<U>(_ transform: (T) -> Result<U>) -> Result<U> {
        switch self {
        case .success(let t): return transform(t)
        case .failure(let e): return .failure(e)
        }
    }
}

func sequence<T>(_ ts: [Result<T>]) -> Result<[T]> {
    return ts.reduce(.success([])) { acc, t in
        return acc.flatMap { xs in t.map { x in xs + [x] } }
    }
}

func traverse<T, U>(_ ts: [T], _ f: (T) -> Result<U>) -> Result<[U]> {
    return sequence(ts.map(f))
}
