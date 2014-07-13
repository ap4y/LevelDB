//
//  LevelDBEnumerator.h
//  LevelDB
//
//  Created by ap4y on 13/07/14.
//  Copyright (c) 2014 ap4y. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const LevelDBEnumeratorResultKey;
extern NSString * const LevelDBEnumeratorResultValue;

@interface DatabaseEnumerator: NSEnumerator

- (void)seekTillPrefix:(NSString *)prefix;
- (NSArray *)allObjectsUntilPrefix:(NSString *)prefix;
- (NSArray *)allObjectsWithPrefix:(NSString *)prefix;

@end