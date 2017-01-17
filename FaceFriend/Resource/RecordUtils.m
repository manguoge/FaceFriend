//
//  RecordUtils.m
//  CustomCamera
//
//  Created by comfouriertech on 16/8/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "RecordUtils.h"

@implementation RecordUtils
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType
                                 fromConnections:(NSArray *)connections
{
    // 遍历传入的所有AVCaptureConnection
    for(AVCaptureConnection *connection in connections )
    {
        // 遍历AVCaptureConnection关联的所有AVCaptureInputPort
        for(AVCaptureInputPort *port in [connection inputPorts])
        {
            // 如果某个AVCaptureInputPort的媒体类型等于要查找的mediaType
            if([port.mediaType isEqual:mediaType])
            {
                // 返回该AVCaptureConnection
                return connection;
            }
        }
    }
    return nil;
}
@end
