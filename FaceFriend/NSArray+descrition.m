//
//  NSArray+descrition.m
//  Scan_QR_AVFoundation
//
//  Created by comfouriertech on 16/9/1.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "NSArray+descrition.h"

@implementation NSArray (descrition)
-(NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self)
    {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    //NSLog(@"descriptionWithLocale");
    
    return str;
}
@end
