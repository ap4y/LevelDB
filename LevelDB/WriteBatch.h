//
//  WriteBatch.h
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WriteBatch: NSObject

- (void)putKey:(NSString *)key value:(NSString *)value;
- (void)deleteKey:(NSString *)key;
- (void)clearAll;

@end