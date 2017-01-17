//
//  SZFriendInfo.h
//  FaceFriend
//
//  Created by comfouriertech on 16/10/9.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//
/*
    实际开发，通过网络从后台获取推荐人的信息模型
 */

#import <Foundation/Foundation.h>

@interface SZFriendInfoModel : NSObject
@property (nonatomic,strong) UIImage* faceImage;
@property (nonatomic,strong) NSString* nickName;
@property (nonatomic,strong) NSString* sex;
@property (nonatomic,strong) NSString* signature;
//前期开发
-(instancetype)initWithFace:(UIImage*)faceImage name:(NSString*)nickName sex:(NSString*)sex signature:(NSString*)signature;
@end
