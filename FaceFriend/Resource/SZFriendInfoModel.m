//
//  SZFriendInfo.m
//  FaceFriend
//
//  Created by comfouriertech on 16/10/9.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZFriendInfoModel.h"

@implementation SZFriendInfoModel
-(instancetype)initWithFace:(UIImage *)faceImage name:(NSString *)nickName sex:(NSString *)sex signature:(NSString *)signature
{
    if (self=[super init])
    {
        self.faceImage=faceImage;
        self.nickName=nickName;
        self.sex=sex;
        self.signature=signature;
    }
    return self;
}
@end
