//
//  TSColorCell.m
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/13.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import "TSColorCell.h"
#import "TSTableView.h"
#import "TSAppDelegate.h"
#import "TSAppDelegate(useful).h"
#import "TSScriptSupport.h"


@implementation TSColorCell
- (id)init {
	self = [super init];
	if (self) {
		_baseColor = [[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] copy];
		_frameColor = [[NSColor colorWithCalibratedWhite:0.65 alpha:1.0] copy];
		_gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.90 alpha:1.0]
																							endingColor:[NSColor colorWithCalibratedWhite:0.70	alpha:1.0]];
	}
	return self;
}


- (id)initWithCoder:aCoder {
	self = [super initWithCoder:aCoder];
	if (self) {
		_baseColor = [[NSColor colorWithCalibratedWhite:0.5 alpha:1.0] copy];
		_frameColor = [[NSColor colorWithCalibratedWhite:0.65 alpha:1.0] copy];
		_gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.90 alpha:1.0]
																							endingColor:[NSColor colorWithCalibratedWhite:0.70	alpha:1.0]];
	}
	return self;
}



//@synthesize selectColor = _selectColor;

- (void)dealloc {
  
	_baseColor = nil;
	_frameColor = nil;
	_gradient = nil;
	
}

- (void)setSelectColor:(NSColor *)aColor atRow:(NSInteger)row {
  
  NSRect frame = [(NSTableView *)[self controlView] frameOfCellAtColumn:1 row:row];
  
  [[NSApp delegate] replaceValue:[aColor copy] atRow:row];
  [[self controlView] setNeedsDisplayInRect:frame];
  
}


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView  {
	
	CGFloat frameWidth;
  
	if (cellFrame.size.width > 40.0) {
		frameWidth = 4.0;
	}
	else {
		frameWidth = 3.0;
	}
  if (cellFrame.size.width > 90.0) {
    cellFrame.size.width = 90.0;
  }
  
  NSInteger row = [(NSTableView *)controlView rowAtPoint:NSMakePoint(NSMidX(cellFrame), NSMidY(cellFrame))];
  NSColor *contentsColor = [[NSApp delegate] valueAtRow:row];
  
  
	NSRect innerFrame = NSInsetRect(cellFrame, frameWidth, frameWidth);
	
	
	[NSGraphicsContext saveGraphicsState];
	
	[_baseColor set];
	NSRectFill(cellFrame);
	
	
	[_gradient drawInRect:NSInsetRect(cellFrame, 1, 1) angle:90];
  
  
  if ( 0 <= row && contentsColor ) {
    [contentsColor set];
    NSRectFill(innerFrame);
  }
  
	[_frameColor set];
	NSFrameRectWithWidth(innerFrame, 1.0);
	
	[NSGraphicsContext restoreGraphicsState];
	
}


//accept mouse event over write from NSCell

- (BOOL)startTrackingAt:(NSPoint)startPoint inView:(NSView *)controlView {
  return YES;
}



- (void)stopTracking:(NSPoint)lastPoint at:(NSPoint)stopPoint inView:(NSView *)controlView mouseIsUp:(BOOL)flag {
  
  NSColorPanel *panel = [NSColorPanel sharedColorPanel];
  NSInteger row = [(TSTableView *)controlView rowAtPoint:stopPoint];
  
  
  TSColorCell *cell = (TSColorCell *)[[(TSAppDelegate *)[NSApp delegate] cells] objectAtIndex:row];
  
  [panel setTarget:nil];
  [(TSTableView *)controlView setColorCell:nil atRow:-1];
  
  [panel setColor:[[NSApp delegate] valueAtRow:row]];
  [(TSTableView *)controlView setColorCell:cell atRow:row];
  [panel setContinuous:YES];
  [panel setTarget:controlView];
  [panel orderFront:controlView];
  
}


@end
