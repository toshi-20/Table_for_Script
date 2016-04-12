//
//  TSAppDelegate(useful).m
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/12.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import "TSAppDelegate(useful).h"
#import "TSColorCell.h"

@implementation TSAppDelegate(useful)


- (NSInteger)typeOfAEKeyword:(AEKeyword)key {
  
  if (key == 'AVle' || key == 'BVle' || key == 'CVle' || key == 'DVle' || key == 'EVle' ||
      key == 'FVle' || key == 'GVle' || key == 'HVle' || key == 'IVle' || key == 'JVle' ||
      key == 'KVle' || key == 'LVle' || key == 'MVle' || key == 'NVle' || key == 'OVle' ||
      key == 'PVle' || key == 'QVle' || key == 'RVle' || key == 'SVle' || key == 'TVle') {
    
    return VALUE;
    
  }
  else if (key == 'ABol' || key == 'BBol' || key == 'CBol' || key == 'DBol' || key == 'EBol' ||
           key == 'FBol' || key == 'GBol' || key == 'HBol' || key == 'IBol' || key == 'JBol' ||
           key == 'KBol' || key == 'LBol' || key == 'MBol' || key == 'NBol' || key == 'OBol' ||
           key == 'PBol' || key == 'QBol' || key == 'RBol' || key == 'SBol' || key == 'TBol') {
    
    return BOOLEAN;
    
  }
  else if (key == 'ALst' || key == 'BLst' || key == 'CLst' || key == 'DLst' || key == 'ELst' ||
           key == 'FLst' || key == 'GLst' || key == 'HLst' || key == 'ILst' || key == 'JLst' ||
           key == 'KLst' || key == 'LLst' || key == 'MLst' || key == 'NLst' || key == 'OLst' ||
           key == 'PLst' || key == 'QLst' || key == 'RLst' || key == 'SLst' || key == 'TLst') {
    
    return LIST;
  }
  else if (key == 'AClr' || key == 'BClr' || key == 'CClr' || key == 'DClr' || key == 'EClr' ||
           key == 'FClr' || key == 'GClr' || key == 'HClr' || key == 'IClr' || key == 'JClr' ||
           key == 'KClr' || key == 'LClr' || key == 'MClr' || key == 'NClr' || key == 'OClr' ||
           key == 'PClr' || key == 'QClr' || key == 'RClr' || key == 'SClr' || key == 'TClr') {
    
    return COLOR;
  }
  return NON;
}

- (NSString *)titleAtRow:(NSUInteger)row {
  return [[[self.tableDatas objectAtIndex:row ] allKeys] objectAtIndex:0];
}

- (id)valueAtRow:(NSUInteger)row {
  NSDictionary *dict;
  
  dict = [[[self.tableDatas objectAtIndex:row] allValues] objectAtIndex:0];
  return [[dict objectForKey:@"value"] objectAtIndex:1];
}


- (id)defaultValueAtRow:(NSUInteger)row {
  NSDictionary *dict;
  
  dict = [[[self.tableDatas objectAtIndex:row] allValues] objectAtIndex:0];
  return [[dict objectForKey:@"value"] objectAtIndex:0];
  
}

- (void)replaceValue:(id)value atRow:(NSUInteger)row {
  NSDictionary *dict;
  
  dict = [[[self.tableDatas objectAtIndex:row] allValues] objectAtIndex:0];
  [(NSMutableArray *)[dict objectForKey:@"value"] replaceObjectAtIndex:1 withObject:value];
}

- (AEKeyword)keywordAtRow:(NSUInteger)row {
  NSDictionary *dict;
  dict = [[[self.tableDatas objectAtIndex:row] allValues] objectAtIndex:0];
  return [[dict objectForKey:@"key"] intValue];
}

- (NSCell *)cellAtRow:(NSUInteger)row {
  id cell;
  AEKeyword word = [self keywordAtRow:row];
  NSUInteger type = [self typeOfAEKeyword:word];
  
  switch (type) {
    case VALUE:
      cell = [[NSTextFieldCell alloc] init];
      break;
      
    case BOOLEAN:
      cell = [[NSButtonCell alloc] init];
      [cell setButtonType:NSSwitchButton];
      [cell setTitle:@""];
      break;
      
    case LIST:
      cell = [[NSPopUpButtonCell alloc ] init];
      [cell setControlSize:NSSmallControlSize];
      [cell setMenu:[self popUpMenuAtRow:row]];
      break;
      
    case COLOR:
      cell = [[TSColorCell alloc] init];
      
    default:
      break;
  }
  return cell;
}

- (NSMenu *)popUpMenuAtRow:(NSUInteger)row {
  AEKeyword word = [self keywordAtRow:row];
  NSMenu *menu;
  NSMenuItem *menuItem;
  NSArray *values;
  
  if ([self typeOfAEKeyword:word] != LIST) {
    return nil;
  }
  if (![[self defaultValueAtRow:row] isKindOfClass:[NSArray class]]) {
  }
  
  menu = [[NSMenu alloc] init];
  
  values = [self defaultValueAtRow:row];//リストの場合{ 配列, currentIndex }という形式になっている.
  NSUInteger i, c = [values count];
  for (i=0; i<c; i++) {
    menuItem = [[NSMenuItem alloc] initWithTitle:[values objectAtIndex:i]
                                          action:nil
                                   keyEquivalent:@""];
    [menuItem setTag:i];
    [menu addItem:menuItem];
  }
  return menu;
}

- (NSDictionary *)resultDictionary {
  return @{@"result" : self.tableDatas};
}






- (NSString *)keywordOfAEKeyword:(AEKeyword)key {
  switch (key) {
    case 'AVle':
      return @"a Value";
    case 'BVle':
      return @"b Value";
    case 'CVle':
      return @"c Value";
    case 'DVle':
      return @"d Value";
    case 'EVle':
      return @"e Value";
    case 'FVle':
      return @"f Value";
    case 'GVle':
      return @"g Value";
    case 'HVle':
      return @"h Value";
    case 'IVle':
      return @"i Value";
    case 'JVle':
      return @"j Value";
    case 'KVle':
      return @"k Value";
    case 'LVle':
      return @"l Value";
    case 'MVle':
      return @"m Value";
    case 'NVle':
      return @"n Value";
    case 'OVle':
      return @"o Value";
    case 'PVle':
      return @"p Value";
    case 'QVle':
      return @"q Value";
    case 'RVle':
      return @"r Value";
    case 'SVle':
      return @"s Value";
    case 'TVle':
      return @"t Value";
      
    case 'ABol':
      return @"a Bool";
    case 'BBol':
      return @"b Bool";
    case 'CBol':
      return @"c Bool";
    case 'DBol':
      return @"d Bool";
    case 'EBol':
      return @"e Bool";
    case 'FBol':
      return @"f Bool";
    case 'GBol':
      return @"g Bool";
    case 'HBol':
      return @"h Bool";
    case 'IBol':
      return @"i Bool";
    case 'JBol':
      return @"j Bool";
    case 'KBol':
      return @"k Bool";
    case 'LBol':
      return @"l Bool";
    case 'MBol':
      return @"m Bool";
    case 'NBol':
      return @"n Bool";
    case 'OBol':
      return @"o Bool";
    case 'PBol':
      return @"p Bool";
    case 'QBol':
      return @"q Bool";
    case 'RBol':
      return @"r Bool";
    case 'SBol':
      return @"s Bool";
    case 'TBol':
      return @"t Bool";
      
    case 'ALst':
      return @"a List";
    case 'BLst':
      return @"b List";
    case 'CLst':
      return @"c List";
    case 'DLst':
      return @"d List";
    case 'ELst':
      return @"e List";
    case 'FLst':
      return @"f List";
    case 'GLst':
      return @"g List";
    case 'HLst':
      return @"h List";
    case 'ILst':
      return @"i List";
    case 'JLst':
      return @"j List";
    case 'KLst':
      return @"k List";
    case 'LLst':
      return @"l List";
    case 'MLst':
      return @"m List";
    case 'NLst':
      return @"n List";
    case 'OLst':
      return @"o List";
    case 'PLst':
      return @"p List";
    case 'QLst':
      return @"q List";
    case 'RLst':
      return @"r List";
    case 'SLst':
      return @"s List";
    case 'TLst':
      return @"t List";
      
    case 'AClr':
      return @"a Color";
    case 'BClr':
      return @"b Color";
    case 'CClr':
      return @"c Color";
    case 'DClr':
      return @"d Color";
    case 'EClr':
      return @"e Color";
    case 'FClr':
      return @"f Color";
    case 'GClr':
      return @"g Color";
    case 'HClr':
      return @"h Color";
    case 'IClr':
      return @"i Color";
    case 'JClr':
      return @"j Color";
    case 'KClr':
      return @"k Color";
    case 'LClr':
      return @"l Color";
    case 'MClr':
      return @"m Color";
    case 'NClr':
      return @"n Color";
    case 'OClr':
      return @"o Color";
    case 'PClr':
      return @"p Color";
    case 'QClr':
      return @"q Color";
    case 'RClr':
      return @"r Color";
    case 'SClr':
      return @"s Color";
    case 'TClr':
      return @"t Color";
    default:
      break;
  }
  return @"no key";
}
@end

