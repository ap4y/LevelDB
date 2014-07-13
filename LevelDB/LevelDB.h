//
//  LevelDB.h
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for LevelDB.
FOUNDATION_EXPORT double LevelDBVersionNumber;

//! Project version string for LevelDB.
FOUNDATION_EXPORT const unsigned char LevelDBVersionString[];

#import <LevelDB/Common.h>
#import <LevelDB/DatabaseEnumerator.h>
#import <LevelDB/WriteBatch.h>

@class WriteBatch, DatabaseEnumerator;
@interface LevelDB: NSObject

- (instancetype)initWithDBUrl:(NSURL *)dbUrl;
- (void)closeDB;

+ (BOOL)destroyDBWithDBUrl:(NSURL *)dbUrl error:(NSError **)error;

- (BOOL)putKey:(NSString *)key value:(NSString *)value options:(WriteOptions)options error:(NSError **)error;
- (NSString *)getKey:(NSString *)key options:(ReadOptions)options error:(NSError **)error;
- (BOOL)deleteKey:(NSString *)key options:(WriteOptions)options error:(NSError **)error;
- (BOOL)write:(void (^)(WriteBatch *wb))operationsBlock options:(WriteOptions)options error:(NSError **)error;

- (DatabaseEnumerator *)enumeratorWithOptions:(ReadOptions)options;

@end