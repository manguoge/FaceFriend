//
//  RecordUtils.h
//  CustomCamera
//
//  Created by comfouriertech on 16/8/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface RecordUtils : NSObject
// 工具方法，根据给定媒体类型获取对应的AVCaptureConnection
+ (AVCaptureConnection *)connectionWithMediaType:(NSString *)mediaType
                                 fromConnections:(NSArray *)connections;
@end
