//
//  SZMeController.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZMyInfoView.h"
#import "SZLocationModel.h"
#import "SZEditMyInfoVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SZLoginVC.h"
@interface SZMeVC : UIViewController<MyInfoViewDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) SZMyInfoView* infoView ;
@property (nonatomic,strong) SZLocationModel* locationModel;
@property (nonatomic,strong) SZEditMyInfoVC* editMyInfoVC;
@property (nonatomic,strong) NSArray* itemArray;
@property (nonatomic,strong) UITableView* myTableView;
@end
