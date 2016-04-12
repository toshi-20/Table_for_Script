//
//  TSAppDelegate(useful).h
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/12.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TSAppDelegate.h"

@interface TSAppDelegate (useful)

- (NSInteger)typeOfAEKeyword:(AEKeyword)key;
- (NSString *)titleAtRow:(NSUInteger)row;
- (id)valueAtRow:(NSUInteger)row;
- (id)defaultValueAtRow:(NSUInteger)row;

- (void)replaceValue:(id)value atRow:(NSUInteger)row;


- (AEKeyword)keywordAtRow:(NSUInteger)row;

- (NSCell *)cellAtRow:(NSUInteger)row;
- (NSMenu *)popUpMenuAtRow:(NSUInteger)row;

- (NSDictionary *)resultDictionary;

- (NSString *)keywordOfAEKeyword:(AEKeyword)key;
@end
