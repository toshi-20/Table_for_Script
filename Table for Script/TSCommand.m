//
//  TSCommand.m
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/12.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import "TSCommand.h"
#import "TSScriptSupport.h"
#import "TSAppDelegate.h"
#import "TSAppDelegate(useful).h"

@implementation DisplayTableCommand
- (BOOL)isWellFormed {
  return NO;
}
- (id)executeCommand {
  return [self performDefaultImplementation];
}



- (id)performDefaultImplementation {
  NSUInteger i, c;
  int keyword;
  NSInteger type;
  id value;
  NSMutableArray *newValues;
  NSDictionary *dict = [self directParameter];
  NSDictionary *args = [self arguments];
  
  NSLog(@"toshi");
  [(TSAppDelegate *)[NSApp delegate] setStartingFromScript:YES];
  
  NSMutableArray *titles = [args objectForKey:@"titles"];
  NSString *exp = [args objectForKey:@"explanation"];
  NSString *wTitle = [args objectForKey:@"windowTitle"];
  
  
  NSMutableArray *array = [[NSMutableArray alloc] init];
  c = [dict count]+1;//Apple script の　添字は１から始まるので
  
  /* titlesがない場合 keyで置き換える. (titles replace with key when titles is nil.)*/
  if (!titles || [titles count] != [[dict allKeys] count]) {
    titles = [NSMutableArray array];
    
    for (i=1; i<c; i++) {
      keyword = [[[dict objectForKey:[NSString stringWithFormat:@"%ld", i]] objectForKey:@"key"] intValue];
      [titles addObject:[[NSApp delegate] keywordOfAEKeyword:keyword]];
    }
  }
  
  /*
  if ([titles count] != [[dict allKeys] count]) {
    NSUInteger tc, dc;
    tc = [titles count];
    dc = [[dict allKeys] count];
    
    [[NSAlert alertWithMessageText:@"The count of the titles and values don't match."
                    defaultButton:@"OK"
                  alternateButton:nil
                      otherButton:nil
        informativeTextWithFormat:@"titles is %ld values is %ld", tc, dc] runModal];
    
    
    [NSApp terminateAfterDelay:0.8];
    return nil;
  }
  */
  
  for (i=1; i<c; i++) {
    NSDictionary *obj = [dict objectForKey:[NSString stringWithFormat:@"%ld", i]];
    
    keyword = [[obj objectForKey:@"key"] intValue];
    type = [[NSApp delegate] typeOfAEKeyword:keyword];
    
    switch (type) {
      case VALUE:
        value = [obj objectForKey:@"value"];
        newValues = [NSMutableArray arrayWithArray:@[value, value]];
        break;
        
      case BOOLEAN:
        value = [obj objectForKey:@"value"];
        newValues = [NSMutableArray arrayWithArray:@[value, value]];
        break;
        
      case LIST:
        value = [obj objectForKey:@"value"];
        newValues = [NSMutableArray arrayWithArray:@[value, [value objectAtIndex:0]]];
        break;
        
      case COLOR:
        value = [obj objectForKey:@"value"];
        newValues = [NSMutableArray arrayWithArray:@[value, value]];
        break;
        
      default:
        break;
    }
    [array addObject:@{[titles objectAtIndex:i-1]: @{@"key":[NSNumber numberWithInt:keyword], @"value":newValues}}];//caution i-1
  }
  
  NSLog(@"toshi");
  if (exp) {
    [[NSApp delegate] setText:exp];
  }
  if (wTitle) {
    [[NSApp delegate] setWindowTitle:wTitle];
  }
  [[NSApp delegate] setTableDatas:array];
  [NSApp activateIgnoringOtherApps:YES];
  NSInteger returnCode = [NSApp runModalForWindow:[[NSApp delegate] window]];
  
  if (returnCode == MODAL_OK) {
    [[NSApp delegate] setReturnCode:1];
  }
  else {
    [[NSApp delegate] setReturnCode:-1];
  }
  
  return [[NSApp delegate] resultDictionary];
}

@end


@implementation ListFromTextCommand

- (id)performDefaultImplementation {
  NSArray *array;
  NSString *str = [self directParameter];
  
  if (!str) {
    return nil;
  }
  
  @try {
    array = [str propertyList];
    
  }@catch (NSException *localException) {
    
    return nil;
  }
  
  return array;
}

@end

