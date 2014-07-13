//
//  Helpers.m
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import "Helpers.h"

NSError* errorFromStatus(leveldb::Status status) {
    NSString *message = [NSString stringWithFormat:@"%s", status.ToString().c_str()];
    LevelDBErrorCode errorCode = LevelDBErrorCodeOk;

    if (status.IsNotFound()) { errorCode = LevelDBErrorCodeNotFound; }
    if (status.IsCorruption()) { errorCode = LevelDBErrorCodeCorruption; }
    if (status.IsIOError()) { errorCode = LevelDBErrorCodeIOError; }

    return [NSError errorWithDomain:LevelDBErrorDomain
                               code:errorCode
                           userInfo:@{ NSLocalizedDescriptionKey: message }];
}

leveldb::Slice sliceFromString(NSString *string) {
    size_t stringSize = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    return leveldb::Slice([string UTF8String], stringSize);
}

NSString* stringFromSlice(leveldb::Slice slice) {
    return [[NSString alloc] initWithBytes:slice.data()
                                    length:slice.size()
                                  encoding:NSUTF8StringEncoding];
}

leveldb::ReadOptions adaptReadOptions(ReadOptions readOptions) {
    leveldb::ReadOptions ldbReadOptions;
    ldbReadOptions.verify_checksums = readOptions.verifyChecksums;
    ldbReadOptions.fill_cache = readOptions.fillCache;

    return ldbReadOptions;
}

leveldb::WriteOptions adaptWriteOptions(WriteOptions writeOptions) {
    leveldb::WriteOptions ldbWriteOptions;
    ldbWriteOptions.sync = writeOptions.sync;

    return ldbWriteOptions;
}