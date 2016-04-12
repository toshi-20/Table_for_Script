//
//  TSAppDelegate.h
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/12.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//
//

#import <Cocoa/Cocoa.h>

@interface TSAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>
{
  NSMutableArray *_tableDatas;
  NSMutableArray *_cells;
  IBOutlet NSButton *_OKButton;
  NSInteger _returnCode;
  
  BOOL _startingFromScript;
  
}
@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSTextView *textView;
@property (retain) NSMutableArray *tableDatas;
@property (retain) NSMutableArray *cells;
@property (assign) NSInteger returnCode;
@property (assign) BOOL startingFromScript;

- (void)setText:(NSString *)string;
- (void)setWindowTitle:(NSString *)title;
- (IBAction)buttonAction:(id)sender;

- (void)terminateApplication:(id)sender;
- (void)displayAlert:(id)sender;
@end
