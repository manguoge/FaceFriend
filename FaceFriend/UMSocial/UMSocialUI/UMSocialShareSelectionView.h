//
//  UMSocialShareSelectionView.h
//  SocialSDK
//
//  Created by umeng on 16/4/24.
//  Copyright © 2016年 dongjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UMSocialCore/UMSocialCore.h>

@class UMSocialShareSelectionView;
typedef void(^UMSocialSharePlatformSelectionBlock)(UMSocialShareSelectionView *shareSelectionView, NSIndexPath *indexPath,UMSocialPlatformType platformType);

@interface UMSocialShareSelectionView : UICollectionView

@property (nonatomic, strong) UIView *backgroundGrayView;

@property (nonatomic, strong) NSMutableArray *sharePaltformNames;

@property (nonatomic, assign, readonly) UMSocialPlatformType selectionPlatform;

@property (nonatomic, copy) UMSocialSharePlatformSelectionBlock shareSelectionBlock;

@property (nonatomic, copy) void (^dismissBlock) ();

- (void)show;
@end


