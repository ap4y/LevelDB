//
//  LevelDB.swift
//  Leaf
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

import Foundation

let defaultWriteOptions = WriteOptions(sync: false);
let defaultReadOptions  = ReadOptions(verifyChecksums: false, fillCache: true);

extension LevelDB: Sequence {

    func putKey(key: String, value: String, error: NSErrorPointer) -> Bool {
        return putKey(key, value: value, options: defaultWriteOptions, error: error);
    }

    func getKey(key: String, error: NSErrorPointer) -> String {
        return getKey(key, options: defaultReadOptions, error: error);
    }

    func deleteKey(key: String, error: NSErrorPointer) -> Bool {
        return deleteKey(key, options: defaultWriteOptions, error: error);
    }

    func writeBatch(operations: ((WriteBatch!) -> Void)) -> NSError? {
        var error: NSError?
        let result = write(operations, options: defaultWriteOptions, error: &error)

        return result ? nil : error
    }

    func generate() -> DatabaseEnumerator {
        return enumeratorWithOptions(defaultReadOptions)
    }
}

extension DatabaseEnumerator: Generator {

    func next() -> (String, String)? {
        if let dict = nextObject() as? [String: String] {
            return (dict[LevelDBEnumeratorResultKey]!, dict[LevelDBEnumeratorResultValue]!)
        }

        return nil;
    }

    func allValuesUntilPrefix(prefix: String) -> [(String, String)] {
        let result = allObjectsUntilPrefix(prefix) as [[String: String]]
        return result.map {
            ($0[LevelDBEnumeratorResultKey]!, $0[LevelDBEnumeratorResultValue]!)
        }
    }

    func allValuesWithPrefix(prefix: String) -> [(String, String)] {
        let result = allObjectsWithPrefix(prefix) as [[String: String]]
        return result.map {
            ($0[LevelDBEnumeratorResultKey]!, $0[LevelDBEnumeratorResultValue]!)
        }
    }
}