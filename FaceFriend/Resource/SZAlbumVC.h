//
//  SZAlbumController.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZAlbumScrollView.h"
#import "SZGetImageModel.h"
#import "SZAlbumView.h"
#import "SZPhotoPageVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface SZAlbumVC : UIViewController
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,strong) TXQcloudFrSDK* sdk;
@property (nonatomic,strong) SZAlbumScrollView* albumScrolleView;
@property (nonatomic,strong) NSMutableArray* imagesURLStr;
@property (nonatomic,strong) SZGetImageModel* imageModel;
@property (nonatomic,strong) NSMutableArray* tags;
@property (nonatomic,strong) NSMutableArray* noRepeatTags;
@property (nonatomic,strong) NSMutableArray* imageURLs;
@property (nonatomic,strong) SZPhotoPageVC* albumPageVC;
@property (nonatomic,strong) ALAssetsLibrary* assertsLibrary;
@property (nonatomic,assign) NSUInteger albumCount;
@property (nonatomic,strong) SZAlbumView* firstAlbumView;
@end
