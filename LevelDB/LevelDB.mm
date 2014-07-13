//
//  DB.m
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import "LevelDB.h"
#import "Helpers.h"
#import "leveldb/db.h"
#import "leveldb/write_batch.h"

@interface LevelDB () {
    leveldb::DB *_db;
}
@end

@interface WriteBatch ()
- (instancetype)initWithDBWriteBatch:(leveldb::WriteBatch)writeBatch;
@end

@interface DatabaseEnumerator()
- (instancetype)initWithDB:(leveldb::DB *)db options:(ReadOptions)options;
@end

@implementation LevelDB

NSString * const LevelDBErrorDomain = @"LevelDBErrorDomain";

- (instancetype)initWithDBUrl:(NSURL *)dbUrl {
    self = [super init];
    if (!self) return nil;

    leveldb::Options options;
    leveldb::Status status;

    options.create_if_missing = true;
    status = leveldb::DB::Open(options, [dbUrl.absoluteString UTF8String], &_db);

    if (!status.ok()) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"%s", status.ToString().c_str()];
    }

    return self;
}

- (void)dealloc {
    if (!_db) { return; }
    [self closeDB];
}

- (void)closeDB {
    delete _db;
    _db = NULL;
}

+ (BOOL)destroyDBWithDBUrl:(NSURL *)dbUrl error:(NSError **)error {
    leveldb::Status status;

    status = leveldb::DestroyDB([dbUrl.absoluteString UTF8String], leveldb::Options());

    if (error && !status.ok()) { *error = errorFromStatus(status); }
    return status.ok();
}

- (BOOL)putKey:(NSString *)key value:(NSString *)value options:(WriteOptions)options error:(NSError **)error {
    leveldb::Status status;

    status = _db->Put(adaptWriteOptions(options), sliceFromString(key), sliceFromString(value));

    if (error && !status.ok()) { *error = errorFromStatus(status); }
    return status.ok();
}

- (NSString *)getKey:(NSString *)key options:(ReadOptions)options error:(NSError **)error {
    std::string valueString;
    leveldb::Status status;

    status = _db->Get(adaptReadOptions(options), sliceFromString(key), &valueString);

    if (status.ok()) { return [NSString stringWithUTF8String:valueString.c_str()]; }

    if (error) { *error = errorFromStatus(status); }
    return nil;
}

- (BOOL)deleteKey:(NSString *)key options:(WriteOptions)options error:(NSError **)error {
    std::string valueString;
    leveldb::Status status;

    status = _db->Delete(adaptWriteOptions(options), sliceFromString(key));

    if (error && !status.ok()) { *error = errorFromStatus(status); }
    return status.ok();
}

- (BOOL)write:(void (^)(WriteBatch *wb))operationsBlock options:(WriteOptions)options error:(NSError **)error {
    leveldb::WriteBatch wb;
    leveldb::Status status;
    WriteBatch *writeBatch;

    writeBatch = [[WriteBatch alloc] initWithDBWriteBatch:wb];
    operationsBlock(writeBatch);

    status = _db->Write(adaptWriteOptions(options), &wb);

    if (error && !status.ok()) { *error = errorFromStatus(status); }
    return status.ok();
}

- (DatabaseEnumerator *)enumeratorWithOptions:(ReadOptions)options {
    return [[DatabaseEnumerator alloc] initWithDB:_db options:options];
}

@end

/**
 * Fix for Xcode 6 simulator
 **/
extern "C"{
    size_t fwrite$UNIX2003(const void *a, size_t b, size_t c, FILE *d) {
        return fwrite(a, b, c, d);
    }
}