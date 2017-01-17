//
//  SZFaceFriend.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "SZConversationListVC.h"
#import "SZInfoFaceView.h"
#import "SZFriendInfoModel.h"
@interface SZFaceFriendVC : UIViewController
@property (nonatomic,strong) SZInfoFaceView* infoFaceView;
@property (nonatomic,strong) UIPanGestureRecognizer* panGesture;
@property (nonatomic,strong) NSMutableArray* infoFaceViewArray;
@property (nonatomic,strong) NSArray* facesArray;
@end
