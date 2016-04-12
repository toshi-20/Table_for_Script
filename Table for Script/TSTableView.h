//
//  TSTableView.h
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/14.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TSColorCell;
@interface TSTableView : NSTableView {
  TSColorCell *_colorCell;
  NSInteger _clickedRow;
}
@property (assign) NSInteger clickedRow;
- (void)setColorCell:(TSColorCell *)cell atRow:(NSInteger)row;
- (TSColorCell *)colorCell;
@end
