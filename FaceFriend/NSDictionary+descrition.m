//
//  NSDictionary+descrition.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/21.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "NSDictionary+descrition.h"

@implementation NSDictionary (descrition)

- (NSString *)description
{
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
    for (NSString *key in allKeys) {
        id value= self[key];
        [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
    }
    [str appendString:@"}"];
    
    return str;
}
@end
