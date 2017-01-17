//
//  SZEditMyInfoVC.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/30.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZPickView.h"
#import "UIView+Additions.h"
#import "UITextField+BFKit.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface SZEditMyInfoVC : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,SZPickViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UIScrollView* scroll;
@property (nonatomic,strong) UIImageView* iconView;
@property (nonatomic,strong) UIImageView* iconBgView;
@property (nonatomic,strong) UILabel* noteLabel;
@property (nonatomic,strong) UITableView* tableView;

@property (nonatomic,strong) NSArray* itemsArray;
@property (nonatomic,strong) NSMutableArray* fieldArray;

@property (nonatomic,strong) UITextField* nameField;
@property (nonatomic,strong) UITextField* genderField;
@property (nonatomic,strong) UITextField* signField;

@property (nonatomic,strong) SZPickView* pickView;
@property (nonatomic,assign) int gender;
@property (nonatomic,strong) NSData *portrait;
@property (nonatomic,assign) BOOL otherState;
@property (nonatomic,strong) NSMutableDictionary* userInfoDict;
@property (nonatomic,strong) NSString* nickName;
@property (nonatomic,strong) NSURL* iconImageURL;


@end
