//
//  Options.h
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LevelDBErrorDomain;
typedef NS_ENUM(NSUInteger, LevelDBErrorCode) {
    LevelDBErrorCodeOk,
    LevelDBErrorCodeNotFound,
    LevelDBErrorCodeCorruption,
    LevelDBErrorCodeNotSupported,
    LevelDBErrorCodeInvalidArgument,
    LevelDBErrorCodeIOError
};

typedef struct ReadOptions {
    bool verifyChecksums;
    bool fillCache;
} ReadOptions;

typedef struct WriteOptions {
    bool sync;
} WriteOptions;