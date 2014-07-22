//
//  WriteBatch.m
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import "WriteBatch.h"
#import "Helpers.h"
#import "leveldb/write_batch.h"

@interface WriteBatch () {
    leveldb::WriteBatch *_wb;
}
@end

@implementation WriteBatch

- (instancetype)initWithDBWriteBatch:(leveldb::WriteBatch *)writeBatch {
    self = [super init];
    if (!self) return nil;

    _wb = writeBatch;

    return self;
}

- (void)putKey:(NSString *)key value:(NSString *)value {
    _wb->Put(sliceFromString(key), sliceFromString(value));
}

- (void)deleteKey:(NSString *)key {
    _wb->Delete(sliceFromString(key));
}

- (void)clearAll {
    _wb->Clear();
}

@end