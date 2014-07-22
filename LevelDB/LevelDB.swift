//
//  LevelDB.swift
//  Leaf
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

import Foundation

public let defaultWriteOptions = WriteOptions(sync: false);
public let defaultReadOptions  = ReadOptions(verifyChecksums: false, fillCache: true);

extension LevelDB: Sequence {

    public func putKey(key: String, value: String, error: NSErrorPointer) -> Bool {
        return putKey(key, value: value, options: defaultWriteOptions, error: error);
    }

    public func getKey(key: String, error: NSErrorPointer) -> String? {
        return getKey(key, options: defaultReadOptions, error: error);
    }

    public func deleteKey(key: String, error: NSErrorPointer) -> Bool {
        return deleteKey(key, options: defaultWriteOptions, error: error);
    }

    public func writeBatch(operations: ((WriteBatch!) -> Void)) -> NSError? {
        var error: NSError?
        let result = write(operations, options: defaultWriteOptions, error: &error)

        return result ? nil : error
    }

    public func generate() -> DatabaseEnumerator {
        return enumeratorWithOptions(defaultReadOptions)
    }
}

extension DatabaseEnumerator: Generator {

    public func next() -> (String, String)? {
        if let dict = nextObject() as? [String: String] {
            return (dict[LevelDBEnumeratorResultKey]!, dict[LevelDBEnumeratorResultValue]!)
        }

        return nil;
    }

    public func allValuesUntilPrefix(prefix: String) -> [(String, String)] {
        let result = allObjectsUntilPrefix(prefix) as [[String: String]]
        return result.map {
            ($0[LevelDBEnumeratorResultKey]!, $0[LevelDBEnumeratorResultValue]!)
        }
    }

    public func allValuesWithPrefix(prefix: String) -> [(String, String)] {
        let result = allObjectsWithPrefix(prefix) as [[String: String]]
        return result.map {
            ($0[LevelDBEnumeratorResultKey]!, $0[LevelDBEnumeratorResultValue]!)
        }
    }
}
