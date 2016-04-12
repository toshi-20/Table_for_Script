//
//  TSScriptSupport.h
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/12.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSApplication (scriptCommand)
- (NSInteger)scriptingReturnCode;
- (void)TerminateCommand:(NSScriptCommand *)command;
- (void)terminateAfterDelay:(NSTimeInterval)interval;

- (void)confirmStarting:(NSTimeInterval)interval;
@end


@interface NSAppleEventDescriptor (scriptingDictionary)
- (void)scriptingRecordToDictionary:(NSMutableDictionary *)dic;
@end

@interface NSDictionary (scripting)
+ (NSDictionary *)scriptingRecordWithDescriptor:(NSAppleEventDescriptor *)inDescriptor;
- (NSAppleEventDescriptor *)scriptingRecordDescriptor;
@end

@interface NSArray (scripting)
+ (NSArray *)scriptingListWithDescriptor:(NSAppleEventDescriptor *)inDescriptor;
- (NSAppleEventDescriptor *)scriptingListDescriptor;
@end

@interface NSColor (scripting)
+ (NSColor *)scriptingRGBColorWithDescriptor:(NSAppleEventDescriptor *)inDescriptor;
- (NSAppleEventDescriptor *)scriptingRGBColorDescriptor;

- (BOOL)isEqualColor:(NSColor *)object;
@end