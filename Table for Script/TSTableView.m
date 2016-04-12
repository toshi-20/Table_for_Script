//
//  TSTableView.m
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/14.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import "TSTableView.h"
#import "TSColorCell.h"
#import "TSAppDelegate(useful).h"

@implementation TSTableView

@synthesize clickedRow = _clickedRow;


- (void)setColorCell:(TSColorCell *)cell atRow:(NSInteger)row {
  _colorCell = cell;
  self.clickedRow = row;
}

- (TSColorCell *)colorCell {
  return _colorCell;
}

- (void)changeColor:(id)sender {
  
  NSInteger row = self.clickedRow;
  if (row != -1) {
    if ([self colorCell]) {
      [[self colorCell] setSelectColor:[sender color] atRow:row];
    }
  }
}


@end
