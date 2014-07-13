//
//  LevelDBEnumerator.m
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import "DatabaseEnumerator.h"
#import "Helpers.h"
#import "leveldb/db.h"
#import "leveldb/iterator.h"

NSString * const LevelDBEnumeratorResultKey   = @"LevelDBEnumeratorResultKey";
NSString * const LevelDBEnumeratorResultValue = @"LevelDBEnumeratorResultValue";

@interface DatabaseEnumerator() {
    leveldb::Iterator *_iterator;
}
@end

@implementation DatabaseEnumerator

- (instancetype)initWithDB:(leveldb::DB *)db options:(ReadOptions)options {
    self = [super init];
    if (!self) return nil;

    _iterator = db->NewIterator(adaptReadOptions(options));
    _iterator->SeekToFirst();

    return self;
}

- (void)dealloc {
    delete _iterator;
}

- (void)seekTillPrefix:(NSString *)prefix {
    _iterator->Seek(sliceFromString(prefix));
}

- (NSArray *)allObjectsUntilPrefix:(NSString *)prefix {
    NSMutableArray *objects = [NSMutableArray array];
    while (_iterator->Valid() && _iterator->key().compare(sliceFromString(prefix))) {
        NSDictionary *currentObject = @{
            LevelDBEnumeratorResultKey:   stringFromSlice(_iterator->key()),
            LevelDBEnumeratorResultValue: stringFromSlice(_iterator->value())
        };
        [objects addObject:currentObject];
        _iterator->Next();
    }

    return objects;
}

- (NSArray *)allObjectsWithPrefix:(NSString *)prefix {
    [self seekTillPrefix:prefix];
    NSMutableArray *objects = [NSMutableArray array];
    while (_iterator->Valid()) {
        NSString *key = stringFromSlice(_iterator->key());
        if (![key hasPrefix:prefix]) return objects;

        NSDictionary *currentObject = @{
            LevelDBEnumeratorResultKey:   key,
            LevelDBEnumeratorResultValue: stringFromSlice(_iterator->value())
        };
        [objects addObject:currentObject];
        _iterator->Next();
    }
    
    return objects;
}

#pragma mark - private

- (NSArray *)allObjects {
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *result in self) {
        [objects addObject:result];
    }

    return objects;
}

- (id)nextObject {
    _iterator->Next();
    if (!_iterator->Valid()) return nil;

    return @{
        LevelDBEnumeratorResultKey:   stringFromSlice(_iterator->key()),
        LevelDBEnumeratorResultValue: stringFromSlice(_iterator->value())
    };
}

@end