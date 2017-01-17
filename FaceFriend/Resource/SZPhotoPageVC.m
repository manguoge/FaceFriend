//
//  SZAlbumPageVC.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/24.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZPhotoPageVC.h"
#import "UMSocialUIManager.h"
#import <UMSocialCore/UMSocialCore.h>

@interface SZPhotoPageVC ()

@end

@implementation SZPhotoPageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor grayColor];
    UIBarButtonItem* shareBtn=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Share", nil) style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    [self.navigationItem setRightBarButtonItem:shareBtn];
    UIBarButtonItem* backBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtn:)];
    self.navigationItem.leftBarButtonItem=backBtn;
}


//分享按钮
- (void)share
{
    __weak typeof(self) weakSelf = self;
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInView:nil sharePlatformSelectionBlock:^(UMSocialShareSelectionView *shareSelectionView, NSIndexPath *indexPath, UMSocialPlatformType platformType)
     {
        //[weakSelf disMissShareMenuView];
        [weakSelf shareDataWithPlatform:platformType];
        
    }];
}
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType
{
    // 创建UMSocialMessageObject实例进行分享
    // 分享数据对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString *title = @"友盟social";
    //NSString *url = @"http://ios9quan.9quan.com.cn/www/wine/show/70488/37961/9502";//@"http://wsq.umeng.com";
    NSString *text = NSLocalizedString(@"FaceFriend is a good APP!", nil);
    UIImage *image = [UIImage imageNamed:@"FaceFriend.jpg"];
    
    /* 以下分享类型，开发者可根据需求调用 */
    // 1、纯文本分享
    messageObject.text = text;
    
    // 2、 图片或图文分享
    // 图片分享参数可设置URL、NSData类型
    // 注意：由于iOS系统限制(iOS9+)，非HTTPS的URL图片可能会分享失败
    //UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:text thumImage:image];
    //[shareObject setShareImage:image];
    //messageObject.shareObject = shareObject;
    
//    // 3、视频分享
    UMShareVideoObject *shareObject = [UMShareVideoObject shareObjectWithTitle:title descr:text thumImage:[UIImage imageNamed:@"icon"]];
    [shareObject setVideoUrl:@"http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html"];
//    messageObject.shareObject = shareObject;
//    
//    // 4、 音乐分享
//    UMShareMusicObject *shareObject = [UMShareMusicObject shareObjectWithTitle:title descr:text thumImage:[UIImage imageNamed:@"icon"]];
//    [shareObject setMusicUrl:@"http://music.huoxing.com/upload/20130330/1364651263157_1085.mp3"];
    messageObject.shareObject = shareObject;
//    
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        
        NSString *message = nil;
        if (!error)
        {
            message = [NSString stringWithFormat:@"分享成功"];
        } else
        {
            message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil];
        [alert show];
    }];
}
//返回左按钮
-(void)backBtn:(UIBarButtonItem*)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
