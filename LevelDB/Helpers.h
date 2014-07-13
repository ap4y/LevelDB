//
//  Helpers.h
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "leveldb/status.h"
#import "leveldb/options.h"

NSError* errorFromStatus(leveldb::Status status);

leveldb::Slice sliceFromString(NSString *string);
NSString* stringFromSlice(leveldb::Slice slice);

leveldb::ReadOptions adaptReadOptions(ReadOptions readOptions);
leveldb::WriteOptions adaptWriteOptions(WriteOptions writeOptions);