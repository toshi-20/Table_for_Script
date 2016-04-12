//
//  TSAppDelegate.h
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/12.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//
//

#import "TSAppDelegate.h"
#import "TSAppDelegate(useful).h"
#import "TSColorCell.h"
#import "TSScriptSupport.h"

@implementation TSAppDelegate

- (id)init {
  self = [super init];
  if (self) {
    self.cells = [[NSMutableArray alloc] init];
  }
  return self;
}


@synthesize tableDatas = _tableDatas;
@synthesize cells = _cells;
@synthesize returnCode = _returnCode;
@synthesize startingFromScript = _startingFromScript;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  self.startingFromScript = NO;
  [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
  [NSApp terminateAfterDelay:120.0];
  [NSApp confirmStarting:0.6];
}


- (NSMutableArray *)tableDatas {
  return _tableDatas;
}
- (void)setTableDatas:(NSMutableArray *)tableDatas {
  _tableDatas = tableDatas;
  [self.tableView reloadData];
}

- (void)setWindowTitle:(NSString *)title {
  [self.window setTitle:title];
}


- (void)setText:(NSString *)string {
  NSFont *font = [NSFont fontWithName:@"Helvetica" size:12.0];
  NSDictionary *attrs = @{NSFontAttributeName : font};
  NSTextStorage *textStorage = [[NSTextStorage alloc] initWithString:string
                                                          attributes:attrs];
  
  [[self.textView layoutManager] replaceTextStorage:textStorage];
}


- (IBAction)buttonAction:(id)sender
{
  if ( sender == _OKButton ) {
		[[self window] orderOut:self];
		[NSApp stopModalWithCode:MODAL_OK];
  }
  else {
    [[self window] orderOut:self];
    [NSApp stopModalWithCode:MODAL_CANCEL];
  }
}

- (void)terminateApplication:(id)sender {
  [NSApp terminate:sender];
}

- (void)displayAlert:(id)sender {
  if (![self startingFromScript]) {
    
    [[NSAlert alertWithMessageText:@"ATTENTION"
                     defaultButton:@"Terminate"
                   alternateButton:nil
                       otherButton:nil
         informativeTextWithFormat:@"This application should be started from a script."] runModal];
    
    [NSApp terminate:self];
  }
}
//
// table view data source method
//
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
  if (!self.tableDatas) {
    return 0;
  }
  return [self.tableDatas count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  
  if ([[tableColumn identifier] isEqualToString:@"Title"]) {
    return [self titleAtRow:row];
  }
  
  if ([[tableColumn identifier] isEqualToString:@"Value"]) {
    return [self valueAtRow:row];
  }
  return nil;
}


- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  
  [self replaceValue:object atRow:row];
  
}




//
//table view delegate metohd
//
- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  id cell;
  
  if (!tableColumn) {
    return nil;
  }
  if (!self.tableDatas) {
    return nil;
  }
  
  
  if ([[tableColumn identifier] isEqualToString:@"Value"]) {
    if ([self.cells count] > row) {
      return [self.cells objectAtIndex:row];
    }
    if ( (cell = [self cellAtRow:row]) ) {
      if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        [cell setEditable:YES];
      }
      [self.cells addObject:cell];
      return cell;
    }
    
  }
  return [[NSTextFieldCell alloc] init];
  
}

- (BOOL)tableView:(NSTableView *)tableView
shouldEditTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
  NSLog(@"shouldEditTableColumn:%@ row:%ld", [tableColumn identifier], row );
  return YES;
}


@end

