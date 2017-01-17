//
//  SZLoginVC.m
//  FaceFriend
//
//  Created by comfouriertech on 16/10/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZLoginVC.h"
@interface SZLoginVC()
{
    UIImagePickerControllerSourceType _sourceType;
}
@end
@implementation SZLoginVC
-(instancetype)init
{
    if (self=[super init])
    {
        //1.头部背景
        CGFloat backH=180;
        UIImageView* loginBackGround=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, backH)];
        loginBackGround.userInteractionEnabled=YES;
        loginBackGround.image=[UIImage imageNamed:@"loginBackGround.jpg"];
        UIImageView* faceIcon=[[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH-backH)*0.5, 0, backH, backH)];
        faceIcon.image=[UIImage imageNamed:@"Me.jpg"];
        faceIcon.layer.cornerRadius=backH*0.5;
        faceIcon.layer.masksToBounds=YES;
        faceIcon.userInteractionEnabled=YES;
        self.faceIcon=faceIcon;
        [loginBackGround addSubview:self.faceIcon];
        UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
        tapGesture.numberOfTapsRequired=1;
        tapGesture.numberOfTouchesRequired=1;
        [self.faceIcon addGestureRecognizer:tapGesture];
        
        //2.底部视图
        CGFloat footViewH=200;
        CGFloat marginX=30;
        CGFloat marginY=10;
        UIView* footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, footViewH)];
          //2.1注册按钮
        UIButton* registerBtn=[[UIButton alloc] initWithFrame:CGRectMake(marginX, marginY, 150, 30)];
        registerBtn.tag=0;
        [registerBtn setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
        registerBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
        [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [registerBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [registerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:registerBtn];
          //2.2忘记密码按钮
        UIButton* forgetBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-marginX-150, marginY, 150, 30)];
        forgetBtn.tag=1;
        forgetBtn.titleLabel.font=[UIFont systemFontOfSize:14.];
        [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [forgetBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [forgetBtn setTitle:NSLocalizedString(@"Forget Password", nil) forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:forgetBtn];
          //2.3登录按钮
            //2.3.1账号登录
        UIButton* loginBtn=[[UIButton alloc] initWithFrame:CGRectMake(2*marginX, 2*marginY+30, SCREENWIDTH-4*marginX, 50)];
        loginBtn.tag=2;//标签为2代表账号登录
        loginBtn.layer.cornerRadius=5;
        loginBtn.backgroundColor=[UIColor orangeColor];
        [loginBtn setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:loginBtn];
            //2.3.2QQ账号登录
        UIButton* qqLoginBtn=[[UIButton alloc] initWithFrame:CGRectMake(3*marginX, 3*marginY+30+50, 50, 50)];
        qqLoginBtn.tag=3;//标签为3代表QQ登录
        qqLoginBtn.layer.cornerRadius=25;
        qqLoginBtn.layer.masksToBounds=YES;
        [qqLoginBtn setBackgroundImage:[UIImage imageNamed:@"qqIcon.jpg"] forState:UIControlStateNormal];
        [qqLoginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:qqLoginBtn];
            //2.3.3微信登录
        UIButton* weChatBtn=[[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH-3*marginX-50, 3*marginY+30+50, 50, 50)];
        weChatBtn.tag=4;//标签为4代表微信账号登录
        weChatBtn.layer.cornerRadius=25;
        weChatBtn.layer.masksToBounds=YES;
        [weChatBtn setBackgroundImage:[UIImage imageNamed:@"weChatIcon.jpg"] forState:UIControlStateNormal];
        [weChatBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:weChatBtn];
        //3.tabelView
        self.itemArray=[[NSArray alloc] initWithObjects:NSLocalizedString(@"Account:", nil),NSLocalizedString(@"Password:", nil), nil];
        UITableView* loginTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGTH) style:UITableViewStylePlain];
        loginTableView.delegate=self;
        loginTableView.dataSource=self;
        loginTableView.separatorColor=[UIColor grayColor];
        loginTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
        loginTableView.tableHeaderView=loginBackGround;
        loginTableView.tableFooterView=footView;
        [self.view addSubview:loginTableView];
        
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Login", nil);
    UIBarButtonItem* backBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
    backBtn.tag=5;
    self.navigationItem.leftBarButtonItem=backBtn;
}
//点击手势方法
-(void)tapGestureHandle:(UITapGestureRecognizer*)tapGesture
{
    UIActionSheet* actionSheet=[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Upload Facephoto", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancle",nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"PhotoGraph", nil),NSLocalizedString(@"Album", nil), nil];
    //actionSheet.frame=
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

-(void)btnClick:(UIButton*)btn
{
    switch (btn.tag)
    {
            //注册按钮方法
        case 0:
        {
            SZRegisterVC* registerVC=[[SZRegisterVC alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
            break;
            //忘记密码按钮方法
        case 1:
        {
            SZForgetPasswordVC* forgetPasswordVC=[[SZForgetPasswordVC alloc] init];
            [self.navigationController pushViewController:forgetPasswordVC animated:YES];
        }
            break;
            //账号登录按钮方法
        case 2:
        {
            
        }
            break;
            //QQ登录按钮方法
        case 3:
        {
            
        }
            break;
            //微信登录按钮方法
        case 4:
        {
            
        }
            break;
            //返回按钮方法
        case 5:
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark-UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* index=@"cellIndex";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:index];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:index];
    }
    cell.textLabel.textColor=[UIColor blackColor];
    cell.textLabel.text=[self.itemArray objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    UITextField* field=[[UITextField alloc] initWithFrame:CGRectMake(100, 0, SCREENWIDTH-140, 44)];
    field.delegate=self;
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    switch (indexPath.row)
    {
        case 0:
            field.placeholder=NSLocalizedString(@"Email/TelePhone",nil);
            field.keyboardType=UIKeyboardTypeDefault;
            field.tag=0;
            self.accountField=field;
            cell.imageView.image=[UIImage imageNamed:@"account.jpg"];
            break;
        case 1:
            field.placeholder=NSLocalizedString(@"Password", nil);
            field.secureTextEntry=YES;
            field.tag=1;
            self.passwordField=field;
            cell.imageView.image=[UIImage imageNamed:@"password.jpg"];
            break;
        default:
            break;
    }
    [cell.contentView addSubview:field];
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell  respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;

}
#pragma mark-UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    switch (textField.tag)
    {
        case 0:
        {
            [self.passwordField becomeFirstResponder];
        }
            break;
        case 1:
        {
            [self.accountField becomeFirstResponder];
        }
            break;
        default:
            break;
    }
    return YES;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 0)
        {
            NSLog(@"0");
            _sourceType = UIImagePickerControllerSourceTypeCamera;
            [self selectPhoto];
        }
        else if(buttonIndex == 1)
        {
            NSLog(@"1");
            _sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self selectPhoto];
        }
}

#pragma mark - 选择照片 照片选择代理方法
- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:_sourceType])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        [picker setAllowsEditing:YES];
        [picker setSourceType:_sourceType];
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        NSLog(@"照片源不可用。");
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         
         //NSLog(@"imagePickerController0%@",info);
         UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
         //获取裁剪图片
         //_portrait = [self compressImagePicture:image iconView:_iconView store:_portrait];
         self.faceIcon.image=image;
         if (self.iconImageURL==nil)
         {
             self.iconImageURL=[[NSURL alloc] init];
         }
         //1.如果是从相册获取的照片
         if ([info objectForKey:UIImagePickerControllerReferenceURL])
         {
             self.iconImageURL=[info objectForKey:UIImagePickerControllerReferenceURL];
             NSString* iconImageURL2Str=[NSString stringWithFormat:@"%@",self.iconImageURL];
             [self.userInfoDict setObject:iconImageURL2Str forKey:@"iconURL2Str"];
             //方法1.通知
             NSNotification* notice=[[NSNotification alloc] initWithName:@"iconChange" object:nil userInfo:self.userInfoDict];
             [[NSNotificationCenter defaultCenter] postNotification:notice];
             
         }
         //2.通过拍照获取的照片assets-library://asset/asset.JPG?id=ECE1B9A8-0427-47DE-B029-DFB8F2C8A02F&ext=JPG
         else
         {
             ALAssetsLibrary* assetsLib=[[ALAssetsLibrary alloc] init];
             [assetsLib writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error)
              {
                  //NSLog(@"assetURL2:%@",assetURL);
                  self.iconImageURL=assetURL;
                  NSString* iconImageURL2Str=[NSString stringWithFormat:@"%@",self.iconImageURL];
                  [self.userInfoDict setObject:iconImageURL2Str forKey:@"iconURL2Str"];
                  //方法1.
                  NSNotification* notice=[[NSNotification alloc] initWithName:@"iconChange" object:nil userInfo:self.userInfoDict];
                  [[NSNotificationCenter defaultCenter] postNotification:notice];
                  //方法2.
                  //方法2.保存至偏好设置
                  //[self saveUserInfo:self.userInfoDict];
                  //[USER_DEFAULT setObject:self.iconImageURL forKey:@"iconURL"];
                  //[USER_DEFAULT synchronize];
              }];
         }
     }];
}


@end
