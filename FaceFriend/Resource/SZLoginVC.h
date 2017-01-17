//
//  SZLoginVC.h
//  FaceFriend
//
//  Created by comfouriertech on 16/10/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZRegisterVC.h"
#import "SZForgetPasswordVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface SZLoginVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) NSArray* itemArray;
@property (nonatomic,strong) UITextField* accountField;
@property (nonatomic,strong) UITextField* passwordField;
@property (nonatomic,strong) UIImageView* faceIcon;
@property (nonatomic,strong) NSURL* iconImageURL;
@property (nonatomic,strong) NSMutableDictionary* userInfoDict;
@end
