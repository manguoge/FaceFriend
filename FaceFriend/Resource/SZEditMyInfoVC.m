//
//  SZEditMyInfoVC.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/30.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZEditMyInfoVC.h"

@interface SZEditMyInfoVC ()
{
UIImagePickerControllerSourceType _sourceType;
}
@end

@implementation SZEditMyInfoVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//barButtonItemWithIcon:@"back" target:self action:@selector(backClick:)];
//    UIView* iconBackView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
//    iconBackView.backgroundColor=[UIColor yellowColor];
//    UIImageView* iconView=[[UIImageView alloc] initWithFrame:CGRectMake((SCREENWIDTH-SCREENWIDTH/8)/2, (80-SCREENWIDTH/8)/2, SCREENWIDTH/8, SCREENWIDTH/8)];
//    iconView.image=[UIImage imageNamed:@"Me.jpg"];
//    [iconBackView addSubview:iconView];
//    [self.view addSubview:iconBackView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _nameField.text =@"Andy"; //[_usesInfoDict objectForKey:@"nickname"];
    int gender  = [[_userInfoDict objectForKey:@"gender"]intValue];
    if(gender == 1)
    {
        _genderField.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Famale",@"")];
    }
    else
    {
        _genderField.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Male",@"")];
    }
        
    //[_iconView setImageWithURL:[NSURL URLWithString:[_usesInfoDict objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"timeline_image_placeholder.png"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
}
-(instancetype)init
{
    if (self=[super init])
    {
        NSDictionary* userInfo=[self getUserInfo];
        self.userInfoDict=[NSMutableDictionary dictionaryWithDictionary:userInfo];
        
        [self initUI];
        self.title=NSLocalizedString(@"User Information", nil);
        
        _itemsArray = @[NSLocalizedString(@"Name",@""),NSLocalizedString(@"Gender",@""),NSLocalizedString(@"Signature",@""),NSLocalizedString(@"Account",@""),NSLocalizedString(@"Area",@""),NSLocalizedString(@"QR code",@"")];
        _fieldArray = [[NSMutableArray alloc] init];
        [self addField];
        
    }
    return  self;
}

-(void)initUI
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 220)];
    _iconBgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-187)*0.5, 5, 187, 187)];
    _iconBgView.userInteractionEnabled = YES;
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 19, 150, 150)];
    [self getIconImage];//获取并显示头像
    _iconView.userInteractionEnabled = YES;
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 75.;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userSettingIconTap:)];
    [_iconView addGestureRecognizer:singleTap];
    
    UIView *exitView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44) ];
    UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH -275)*0.5, 5, 275, 44)];
    [exitButton setTitle:NSLocalizedString(@"Finish",@"") forState:UIControlStateNormal];
    exitButton.tag = 3;
    exitButton.backgroundColor = [UIColor orangeColor];
    exitButton.layer.masksToBounds = YES;
    exitButton.layer.cornerRadius = 5.0f;
    [exitButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _noteLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-150)*0.5, CGRectGetMaxY(_iconBgView.frame)+5, 150, 20) ];
    _noteLabel.text=NSLocalizedString(@"Click edit usericon",@"");
    [_noteLabel  setFont:[UIFont systemFontOfSize:15]];
    _noteLabel.textColor=[UIColor blackColor];
    [_noteLabel setTextAlignment:NSTextAlignmentCenter];
    [_noteLabel setNumberOfLines:1];
    [backView addSubview:_iconBgView];
    [_iconBgView addSubview:_iconView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGTH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = backView;
    _tableView.backgroundColor = [UIColor yellowColor];
    [exitView addSubview:exitButton];
    _tableView.tableFooterView = exitView;
    [self.view addSubview:_tableView];
    [backView addSubview:_noteLabel];
}
//获取并并显示头像
-(void)getIconImage
{
    
    NSDictionary* userInfo=[self getUserInfo];
    NSLog(@"%@:",userInfo);
    NSURL* iconURL=[userInfo objectForKey:@"iconURL"];
    if (iconURL!=nil)
    {
        ALAssetsLibrary* assetsLib=[[ALAssetsLibrary alloc] init];
        [assetsLib assetForURL:iconURL resultBlock:^(ALAsset *asset)
         {
             UIImage* icon=[UIImage imageWithCGImage:asset.thumbnail];
             _iconView.image=icon;
         } failureBlock:nil];
    }
    else
    {
        _iconView.image=[UIImage imageNamed:@"Me.jpg"];
    }
    
}

- (void)addField// 5pcs
{
    for (int i = 0; i < 3; i++)
    {
        NSString *textDes = [_itemsArray objectAtIndex:i];
        UITextField *field = [UITextField initWithFrame:CGRectMake(SCREENWIDTH- 250, 7, 220, 30) placeholder:textDes color:[UIColor whiteColor] font:FontNameArialBoldMT size:18. returnType:UIReturnKeyGo keyboardType:UIKeyboardTypeDefault secure:NO borderStyle:UITextBorderStyleNone autoCapitalization:UITextAutocapitalizationTypeNone keyboardAppearance:UIKeyboardAppearanceDefault enablesReturnKeyAutomatically:NO clearButtonMode:UITextFieldViewModeNever autoCorrectionType:UITextAutocorrectionTypeNo delegate:self];
        [field setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        field.textAlignment = NSTextAlignmentRight;
        field.textColor = [UIColor blackColor];
        field.tag = i;
        if (i == 0)
        {
            field.enabled = YES;
            _nameField = field;
        }
        else if (i == 1)
        {
            field.enabled = NO;
            _genderField = field;
        }
        else if(i == 2)
        {
            field.enabled = YES;
            _signField = field;
        }
//        else if(i == 3)
//        {
//            field.enabled = YES;
//            _accountField = field;
//            _accountField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//            _accountField.returnKeyType = UIReturnKeyDone;
//        }else if(i == 4)
//        {
//            field.enabled = NO;
//            _areaField = field;
//        }
        [_fieldArray addObject:field];
    }
}

-(void)backClick
{
    [self saveUserInfo:self.userInfoDict];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)btnClick:(UIButton *)button
{
    [self saveUserInfo:self.userInfoDict];
    [self dismissViewControllerAnimated:YES completion:nil];
    //    [self updateUserInfo];
    return;
    //    if (button.tag == 3) {
    //        NSLog(@"完成");
    //        if ([_editType isEqualToString:@"addmember"]) {
    //            [self updateUserInfo];
    //        }
    //        if ([_editType isEqualToString:@"editmember"]) {
    //            [self checkUserInfo];
    //        }
    //    }
}
- (void)saveUserInfo:(NSDictionary *)dic
{
    [USER_DEFAULT setObject:dic forKey:kUserInfo];
    [USER_DEFAULT synchronize];
}
-(NSDictionary*)getUserInfo
{
    return [USER_DEFAULT objectForKey:kUserInfo];
}

- (void)userSettingIconTap:(UITapGestureRecognizer *)recognizer
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel",@"") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"TakePhoto",@""),NSLocalizedString(@"Album",@""), nil];
    sheet.tag = 0;
    // UIActionSheet最好显示到Window上面
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (NSData *)compressImagePicture:(UIImage *)image iconView:(UIImageView *)iconView store:(NSData *)data
{
    CGFloat min = MIN(image.size.width, image.size.height);
    CGFloat scale = 180.0/min;
    image = [image getSquareImageWithScale:scale];
    iconView.image = image;
    
    data = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"length=%lu",(unsigned long)data.length);
    //判断压缩后的图片大小是否达到范围内，未达到就持续压缩直到达到范围内或者无法再压缩
    float press = 0.2;
    while (data.length > 32000 && press > 0)
    {
        data = UIImageJPEGRepresentation(image, press);
        press = press - 0.1;
    }
    return data;
}

#pragma mark- UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //[self moveView:3];
    NSLog(@"tag =%ld",(long)textField.tag);
    if (textField.tag == 1)
    {
        textField.enabled = NO;
        [textField resignFirstResponder];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag==0)
    {
        [self setValue:textField.text forKey:@"nickName"];
        [self.userInfoDict setObject:textField.text forKey:@"nickName"];
    }
    else if (textField.tag==1)
    {
        [self.userInfoDict setObject:textField.text forKey:@"sex"];
        
    }
    else if (textField.tag==2)
    {
        [self.userInfoDict setObject:textField.text forKey:@"signature"];
    }
    //方法1.个人信息修改之后，发布通知
    //NSNotification* notice=[NSNotification  notificationWithName:@"updateInfo" object:nil userInfo:self.userInfoDict];
    //[[NSNotificationCenter defaultCenter] postNotification:notice];
    
    //方法2.个人信息修改之后，存储到偏好设置里
    [self saveUserInfo:self.userInfoDict];
    
    
    if ([string isEqualToString:@"\n"])
    {
        //[self moveView:4];
        [textField resignFirstResponder];
        [textField endEditing:YES];
        return NO;
    }
    return YES;
}

#pragma mark -TableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fieldArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identified = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identified];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identified];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [_itemsArray objectAtIndex:indexPath.row];
    UITextField *field = [_fieldArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:field];
    //cell.contentView.backgroundColor = [UIColor yellowColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell  respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:NO];}
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{  // 点击后执行的动作
    if (indexPath.row == 0)
    {
        
    }
    else if (indexPath.row == 1)
        {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Famale",@""),NSLocalizedString(@"Male",@""), nil];
            sheet.tag = 1;
            [sheet showInView:_scroll.window];
        }
    else if (indexPath.row == 2)
        {
//            NSDate *date=[NSDate new];
//            _pickView=[[SZPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
//            _pickView.delegate=self;
//            [_pickView show];
        }
//        else if (indexPath.row == 3)
//        {
//            
//        }
//        else if (indexPath.row == 4)
//        {
//            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"General",@""),NSLocalizedString(@"Amateur",@""),NSLocalizedString(@"Professionals",@""), nil];
//            sheet.tag = 4;
//            [sheet showInView:_scroll.window];
//        }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0)
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
    else if(actionSheet.tag == 1)
    {
        NSLog(@"but tag%ld",buttonIndex);// 0是女 1是男
        if (buttonIndex == 0)
        {
            _genderField.text = NSLocalizedString(@"Famale",@"");
            _gender = 0;
        }
        else if (buttonIndex == 1)
        {
            _genderField.text = NSLocalizedString(@"Male",@"");
            _gender = 1;
        }
    }
//    else if(actionSheet.tag == 4)
//    {
//        NSLog(@"but tag%ld",buttonIndex);
//        if (buttonIndex == 0)
//        {
//            _areaField.text = NSLocalizedString(@"General",@"");
//            _level = 0;
//        }else if (buttonIndex == 1)
//        {
//            _areaField.text = NSLocalizedString(@"Amateur",@"");
//            _level = 1;
//        }else if (buttonIndex == 2)
//        {
//            _areaField.text = NSLocalizedString(@"Professionals",@"");
//            _level = 2;
//        }
//    }
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
        _iconView.image=image;
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

#pragma mark SZpickVIewDelegate
-(void)toobarDonBtnHaveClick:(SZPickView *)pickView resultString:(NSString *)resultString{
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSDate *date = [dateFormatter dateFromString:@"2007-10-21"];
    self.signField.text = [resultString substringToIndex:10];
    NSLog(@"data string = %@=",[resultString substringToIndex:10]);
}
@end
