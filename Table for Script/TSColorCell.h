//
//  TSColorCell.h
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/13.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TSColorCell : NSCell {
	
	NSColor *_baseColor;
	NSColor *_frameColor;
	NSGradient *_gradient;
  
  
}

- (void)setSelectColor:(NSColor *)aColor atRow:(NSInteger)row;

@end
