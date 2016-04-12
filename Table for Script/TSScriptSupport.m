//
//  TSScriptSupport.m
//  Table for Script
//
//  Created by Toshifumi Niwa on 2015/03/12.
//  Copyright (c) 2015 niwa design laboratory. All rights reserved.
//

#import "TSScriptSupport.h"
#import "TSAppDelegate.h"
#import "TSAppDelegate(useful).h"

@implementation NSApplication (scriptCommand)

- (NSInteger)scriptingReturnCode {
  return [(TSAppDelegate *)[self delegate] returnCode];
}


- (void)TerminateCommand:(NSScriptCommand *)command {
  
  [self terminateAfterDelay:0.8];
}


- (void)terminateAfterDelay:(NSTimeInterval)interval {
  
  [[NSApp delegate] performSelector:@selector(terminateApplication:)
                         withObject:self
                         afterDelay:interval
                            inModes:[NSArray arrayWithObjects:NSDefaultRunLoopMode, NSModalPanelRunLoopMode, nil]];
}

- (void)confirmStarting:(NSTimeInterval)interval {
  
  [[NSApp delegate] performSelector:@selector(displayAlert:)
                         withObject:self
                         afterDelay:interval
                            inModes:[NSArray arrayWithObjects:NSDefaultRunLoopMode, NSModalPanelRunLoopMode, nil]];
}


@end


@implementation NSAppleEventDescriptor (scriptingDictionary)

- (void)scriptingRecordToDictionary:(NSMutableDictionary *)dic {
  
  NSAppleEventDescriptor *descriptor, *crip ;
  NSInteger type;
  BOOL flag;
  AEKeyword key;
  NSDictionary *subDic;
  id obj;
  
  descriptor = [self coerceToDescriptorType:'reco'];
  NSUInteger i, num = [descriptor numberOfItems];
  
  for (i=1; i<num+1; i++) {
    crip = [descriptor descriptorAtIndex:i];
    key = [descriptor keywordForDescriptorAtIndex:i];
    
    if (!crip) {
      continue;
    }
    if (crip == [NSAppleEventDescriptor nullDescriptor]) {
      continue;
    }
    
    
    type = [[NSApp delegate] typeOfAEKeyword:key];
    switch (type) {
      case VALUE:
        
        obj = [crip stringValue];
        subDic = @{@"key" : [NSNumber numberWithInt:key], @"value" : obj};
        [dic setObject:subDic forKey:[NSString stringWithFormat:@"%ld", i]];
        break;
        
      case BOOLEAN:
        
        NSLog(@"flag:%@", [crip booleanValue] == true ? @"YES" : @"NO");
        flag = [crip booleanValue] == true ? YES : NO;
        obj = [NSNumber numberWithBool:flag];
        subDic = @{@"key": [NSNumber numberWithInt:key], @"value" : obj};
        [dic setObject:subDic forKey:[NSString stringWithFormat:@"%ld", i]];
        break;
        
      case LIST:
        
        obj = [NSArray scriptingListWithDescriptor:crip];
        subDic = @{@"key": [NSNumber numberWithInt:key], @"value" : obj};
        [dic setObject:subDic forKey:[NSString stringWithFormat:@"%ld", i]];
        break;
        
      case COLOR:
        
        obj = [NSColor scriptingRGBColorWithDescriptor:crip];
        subDic = @{@"key": [NSNumber numberWithInt:key], @"value" : obj};
        [dic setObject:subDic forKey:[NSString stringWithFormat:@"%ld", i]];
      default:
        break;
    }
  }
}
@end


@implementation NSDictionary (scripting)


+(NSDictionary *)scriptingRecordWithDescriptor:(NSAppleEventDescriptor *)inDescriptor {
  
  NSAppleEventDescriptor *descriptor;
  
  
  descriptor = [inDescriptor coerceToDescriptorType:'reco'];
  
  NSMutableDictionary *dic = [NSMutableDictionary dictionary];
  [descriptor scriptingRecordToDictionary:dic];
  return dic;
}




- (NSAppleEventDescriptor *)scriptingRecordDescriptor {
  
  id object;
  NSDictionary *dict;
  NSAppleEventDescriptor *recordDescriptor = [NSAppleEventDescriptor recordDescriptor];
  NSAppleEventDescriptor *listDescriptor;
  NSAppleEventDescriptor *strDescriptor;
  NSUInteger index;
  NSArray *tableDatas = [self objectForKey:@"result"];
  NSArray *values;
  BOOL flag = YES;
  AEKeyword keyword;
  
  NSUInteger i, c = [tableDatas count];
  
  for (i=0; i<c; i++) {
    dict = [tableDatas objectAtIndex:i];
    
    keyword = [[[[dict allValues] firstObject] objectForKey:@"key"] intValue];
    values = [[[dict allValues] firstObject] objectForKey:@"value"];
    
    if ([[NSApp delegate] typeOfAEKeyword:keyword] == VALUE) {
      
      strDescriptor = [NSAppleEventDescriptor descriptorWithString:[values objectAtIndex:1]];
    }
    else if ([[NSApp delegate] typeOfAEKeyword:keyword] == BOOLEAN) {
      
      flag = [[values objectAtIndex:1] boolValue];
      strDescriptor = [NSAppleEventDescriptor descriptorWithBoolean:flag];
    }
    else if ([[NSApp delegate] typeOfAEKeyword:keyword] == LIST) {
      
      listDescriptor = [NSAppleEventDescriptor listDescriptor];
      index = [[values objectAtIndex:1] integerValue];
      object = [[values objectAtIndex:0] objectAtIndex:index];
      strDescriptor = [NSAppleEventDescriptor descriptorWithString:object];
      [listDescriptor insertDescriptor:strDescriptor atIndex:0];
    }
    else if ([[NSApp delegate] typeOfAEKeyword:keyword] == COLOR) {
      
      strDescriptor = [[values objectAtIndex:1] scriptingRGBColorDescriptor];
    }
    else {
      strDescriptor = [NSAppleEventDescriptor nullDescriptor];
    }
    
    [recordDescriptor setDescriptor:strDescriptor forKeyword:keyword];
  }
  
  return recordDescriptor;
}




@end


@implementation NSArray (scripting)


+ (NSArray *)scriptingListWithDescriptor:(NSAppleEventDescriptor *)inDescriptor {
  
  const double *d;
  NSUInteger type;
  NSUInteger i, c = [inDescriptor numberOfItems];
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:c];
  NSAppleEventDescriptor *descriptor;
  
  for (i=1; i<=c; i++) {
    descriptor = [inDescriptor descriptorAtIndex:i];
    type = [descriptor descriptorType];
    
    switch (type) {
      case typeUnicodeText:
        [array addObject:[descriptor stringValue]];
        break;
        
      case typeCFStringRef:
        [array addObject:[descriptor stringValue]];
        break;
        
      case typeIEEE64BitFloatingPoint:
        d = (const double *)[[descriptor data] bytes];
        [array addObject:[NSNumber numberWithDouble:*d]];
        break;
        
      case typeIEEE32BitFloatingPoint:
        d = (const double *)[[descriptor data] bytes];
        [array addObject:[NSNumber numberWithDouble:*d]];
        break;
        
      case typeSInt32:
        [array addObject:[NSNumber numberWithInt:[descriptor int32Value]]];
        break;
        
      case typeBoolean:
        [array addObject:[NSNumber numberWithBool:[descriptor booleanValue]]];
        break;
        
      case typeAEList:
        [array addObject:[NSArray scriptingListWithDescriptor:descriptor]];
        break;
        
      case typeAERecord:
        [array addObject:[NSDictionary scriptingRecordWithDescriptor:descriptor]];
        break;
        
      default:
        break;
    }
  }
  return array;
}


- (NSAppleEventDescriptor *)scriptingListDescriptor {
  
  
  
  NSAppleEventDescriptor *strDes;
  NSUInteger i, c = [self count];
  double d;
  
  
  NSAppleEventDescriptor *listDescriptor = [NSAppleEventDescriptor listDescriptor];
  
  for (i=0; i<c; i++) {
    if ([[self objectAtIndex:i] isKindOfClass:[NSString class]]) {
      strDes = [NSAppleEventDescriptor descriptorWithString:[self objectAtIndex:i]];
    }
    else if ([[self objectAtIndex:i] isKindOfClass:[NSArray class]]) {
      strDes = [[self objectAtIndex:i] scriptingListDescriptor];
    }
    else if ([[self objectAtIndex:i] isKindOfClass:[NSScriptObjectSpecifier class]]) {
      strDes = [[self objectAtIndex:i] descriptor];
    }
    else {
      d = [[self objectAtIndex:i] doubleValue];
      strDes = [NSAppleEventDescriptor descriptorWithString:[NSString stringWithFormat:@"%g", d]];
    }
    [listDescriptor insertDescriptor:strDes atIndex:0];
  }
  
  return listDescriptor;
}

@end



@implementation NSColor(scripting)


+ (NSColor *)scriptingRGBColorWithDescriptor:(NSAppleEventDescriptor *)inDescriptor {
  NSColor *color = nil;
  NSAppleEventDescriptor *rgbColorDescriptor = [inDescriptor coerceToDescriptorType:typeRGBColor];
  if (rgbColorDescriptor) {
    
    NSData *descriptorData = [rgbColorDescriptor data];
    if ([descriptorData length]==sizeof(RGBColor)) {
      const RGBColor *qdColor = (const RGBColor *)[descriptorData bytes];
      color = [NSColor colorWithCalibratedRed:((CGFloat)qdColor->red / 65535.0f)
                                        green:((CGFloat)qdColor->green / 65535.0f)
                                         blue:((CGFloat)qdColor->blue / 65535.0f)
                                        alpha:1.0];
    }
    
  }
  return color;
  
}



- (NSAppleEventDescriptor *)scriptingRGBColorDescriptor {
  NSColor *colorAsCalibratedRGB = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
  RGBColor qdColor;
  qdColor.red = (unsigned short)([colorAsCalibratedRGB redComponent] * 65535.0f);
  qdColor.green = (unsigned short)([colorAsCalibratedRGB greenComponent] * 65535.0f);
  qdColor.blue = (unsigned short)([colorAsCalibratedRGB blueComponent] * 65535.0f);
  
  return [NSAppleEventDescriptor descriptorWithDescriptorType:typeRGBColor bytes:&qdColor length:sizeof(RGBColor)];
  
}

- (BOOL)isEqualColor:(NSColor *)object {
  if (!object) {
    return NO;
  }
  if (  fabs(self.redComponent - object.redComponent) < 0.001 &&
        fabs(self.greenComponent - object.greenComponent) < 0.001 &&
        fabs(self.blueComponent - object.blueComponent) < 0.001 ) {
    return YES;
  }
  return NO;
}
@end
