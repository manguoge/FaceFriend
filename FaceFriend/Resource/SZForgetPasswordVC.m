//
//  SZForgetPasswordVC.m
//  FaceFriend
//
//  Created by comfouriertech on 16/10/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZForgetPasswordVC.h"

@implementation SZForgetPasswordVC
-(instancetype)init
{
    if (self=[super init])
    {
        self.itemArray=[NSArray arrayWithObjects:NSLocalizedString(@"Account:", nil),NSLocalizedString(@"Verification Code:", nil),NSLocalizedString(@"New Password:", nil),NSLocalizedString(@"Confirm Password:", nil), nil];
        //1.注册TableView
        UITableView* seekTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGTH-44) style:UITableViewStyleGrouped];
        seekTableView.dataSource=self;
        seekTableView.delegate=self;
        [self.view addSubview:seekTableView];
        //2.头部视图//背景图片
        UIImageView* headView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 180)];
        headView.image=[UIImage imageNamed:@"seekPassword.jpg"];
        [seekTableView setTableHeaderView:headView];
        //3.底部视图//注册按钮
        UIView* footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
        UIButton* nextBtn=[[UIButton alloc] initWithFrame:CGRectMake(80, 10, SCREENWIDTH-160, 50)];
        nextBtn.tag=0;
        nextBtn.layer.cornerRadius=5;
        nextBtn.backgroundColor=[UIColor orangeColor];
        [nextBtn setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:nextBtn];
        [seekTableView setTableFooterView:footView];
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedString(@"Seek Password", nil);
    UIBarButtonItem* backBtn=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
    backBtn.tag=2;
    self.navigationItem.leftBarButtonItem=backBtn;
}
-(void)btnClick:(UIButton*)btn
{
    switch (btn.tag)
    {
        //下一步按钮方法
        case 0:
        {
            
        }
            break;
        //验证码按钮方法
        case 1:
        {
            
        }
            break;
        //返回按钮方法
        case 2:
        {
            [self.navigationController popViewControllerAnimated:YES];
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
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    //cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    UITextField* field=[[UITextField alloc] initWithFrame:CGRectMake(125, 0, SCREENWIDTH-130, 44)];
    field.delegate=self;
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    
    switch (indexPath.row)
    {
        case 0:
        {
            field.placeholder=NSLocalizedString(@"Email/TelePhone",nil);
            field.keyboardType=UIKeyboardTypeDefault;
        }
            break;
        case 1:
        {
            field.placeholder=NSLocalizedString(@"Confirm Code", nil);
            UIButton* codeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
            codeBtn.layer.cornerRadius=5;
            codeBtn.backgroundColor=[UIColor orangeColor];
            codeBtn.tag=1;
            [codeBtn setTitle:NSLocalizedString(@"Verification Code", nil) forState:UIControlStateNormal];
            [codeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            field.rightView=codeBtn;
            field.rightViewMode = UITextFieldViewModeAlways;
        }
            break;
        case 2:
        {
            field.placeholder=NSLocalizedString(@"Password", nil);
            field.secureTextEntry=YES;
        }
            break;
        case 3:
        {
            field.placeholder=NSLocalizedString(@"Confirm Password", nil);
            field.secureTextEntry=YES;
        }
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
    return YES;
}

@end
