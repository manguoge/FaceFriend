//
//  SZRegisterVC.m
//  FaceFriend
//
//  Created by comfouriertech on 16/10/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZRegisterVC.h"

@implementation SZRegisterVC
-(instancetype)init
{
    if (self=[super init])
    {
        //4.添加触摸背景。 收键盘
        UIControl *backControl = [[UIControl alloc] initWithFrame:self.view.frame];
        backControl.backgroundColor = [UIColor grayColor];
        self.view=backControl;
        [(UIControl *)self.view addTarget:self action:@selector(backgroundTap) forControlEvents:UIControlEventTouchDown];
        //1.注册TableView
        self.itemArray=[NSArray arrayWithObjects:NSLocalizedString(@"Set Account:", nil),NSLocalizedString(@"Set Password:", nil),NSLocalizedString(@"Confirm Password:", nil), nil];
        UITableView* registerTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGTH-44) style:UITableViewStyleGrouped];
        registerTableView.dataSource=self;
        registerTableView.delegate=self;
        [self.view addSubview:registerTableView];
        //2.头部视图//背景图片
        UIImageView* headView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
        headView.image=[UIImage imageNamed:@"registerBackground.jpg"];
        [registerTableView setTableHeaderView:headView];
        //3.底部视图//注册按钮
        UIView* footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
        UIButton* registerBtn=[[UIButton alloc] initWithFrame:CGRectMake(80, 10, SCREENWIDTH-160, 50)];
        registerBtn.layer.cornerRadius=5;
        registerBtn.backgroundColor=[UIColor orangeColor];
        [registerBtn setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(register:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:registerBtn];
        [registerTableView setTableFooterView:footView];
        
        
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=NSLocalizedString(@"Register", nil);
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
}
//点击背景收键盘
-(void)backgroundTap
{
    //动画是执行推上textfield后还原
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);      //还原view
    self.view.frame = rect;
    [UIView commitAnimations];
    [self.accountField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.confirmPasswrdField resignFirstResponder];
}

//注册按钮方法
-(void)register:(UIButton*)btn
{
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    UITextField* field=[[UITextField alloc] initWithFrame:CGRectMake(135, 0, SCREENWIDTH-175, 44)];
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
        case 2:
            field.placeholder=NSLocalizedString(@"Confirm Password", nil);
            field.secureTextEntry=YES;
            field.tag=2;
            self.confirmPasswrdField=field;
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
            [self.confirmPasswrdField becomeFirstResponder];
        }
            break;
        case 2:
        {
            [self.accountField becomeFirstResponder];
        }
            break;
        default:
            break;
    }
    return YES;

}
@end
