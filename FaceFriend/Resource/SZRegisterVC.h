//
//  SZRegisterVC.h
//  FaceFriend
//
//  Created by comfouriertech on 16/10/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZRegisterVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) NSArray* itemArray;
@property (nonatomic,strong) NSArray* textFieldArray;
@property (nonatomic,strong) UITextField* accountField;
@property (nonatomic,strong) UITextField* passwordField;
@property (nonatomic,strong) UITextField* confirmPasswrdField;
@end
