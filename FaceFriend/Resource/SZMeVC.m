//
//  SZMeController.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZMeVC.h"

@implementation SZMeVC
-(instancetype)init
{
    if (self=[super init])
    {
        //1.初始个人信息
        NSMutableDictionary* userInfoDict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Andy",@"nickName",NSLocalizedString(@"Male", nil),@"sex",NSLocalizedString(@"FaceFriend is a good APP!", nil),@"signature",nil];
        [self saveUserInfo:userInfoDict];
        
        SZLocationModel* locationModel=[[SZLocationModel alloc] init];
        NSString* currentCity=[locationModel getCurrentCity];
        //NSLog(@"%@",currentCity);
        //使用KVO模式为定位模型的当前城市属性添加观察者，属性改变时更新视图显示的城市名
        [locationModel addObserver:self forKeyPath:@"currentCity" options:NSKeyValueObservingOptionNew context:nil];
        self.locationModel=locationModel;
        //2.添加我的信息视图//作为tableView的头部视图
        SZMyInfoView* infoView=[[SZMyInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120) icon:[UIImage imageNamed:@"Me.jpg"] name:[userInfoDict objectForKey:@"nickName"] contactNum:10 location:currentCity signature:[userInfoDict objectForKey:@"signature"]];
        infoView.delegate=self;
        self.infoView=infoView;
        //3.添加tableView的底部视图
        UIImageView* footView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        footView.layer.cornerRadius=5;
        footView.layer.masksToBounds=YES;
        footView.image=[UIImage imageNamed:@"versionBackground.jpg"];
        UILabel* versionLabel=[[UILabel alloc] initWithFrame:CGRectMake((SCREENWIDTH-150)*0.5, (50-30)*0.5, 150, 30)];
        versionLabel.textAlignment=NSTextAlignmentCenter;
        versionLabel.text=@"FaceFriend V1.0.0";
        [footView addSubview:versionLabel];
        
        //4.tableView
        self.itemArray=[NSArray arrayWithObjects:NSLocalizedString(@"Account and Password", nil),NSLocalizedString(@"Using Help", nil),NSLocalizedString(@"Feedback", nil),NSLocalizedString(@"Score for me", nil),NSLocalizedString(@"About us", nil), nil];
        UITableView* myTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGTH) style:UITableViewStylePlain];
        myTableView.dataSource=self;
        myTableView.delegate=self;
        myTableView.tableHeaderView=self.infoView;
        myTableView.tableFooterView=footView;
        self.myTableView=myTableView;
        [self.view addSubview:self.myTableView];
    }
    return self;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=NSLocalizedString(@"Me", nil);
    
    //使用通知模式
    NSNotificationCenter* center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateInfoView:) name:@"updateInfo" object:nil];
    [center addObserver:self selector:@selector(updateInfoView:) name:@"iconChange" object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary* userInfo=[self getUserInfo];
    //NSLog(@"%@:",userInfo);
    self.infoView.nameLabel.text=[userInfo objectForKey:@"nickName"];
    self.infoView.signatureLabel.text=[userInfo objectForKey:@"signature"];
    //NSURL* iconURL=[userInfo objectForKey:@"iconURL"];
    //[self getIconImage:iconURL];//获取并并显示头像
    
}
//获取并并显示头像
-(void)getIconImage:(NSURL*)url
{
    if (url!=nil)
    {
        ALAssetsLibrary* assetsLib=[[ALAssetsLibrary alloc] init];
        [assetsLib assetForURL:url resultBlock:^(ALAsset *asset)
         {
             UIImage* icon=[UIImage imageWithCGImage:asset.thumbnail];
             [self.infoView.iconBtnView setBackgroundImage:icon forState:UIControlStateNormal];
         } failureBlock:nil];
    }
    else
    {
        [self.infoView.iconBtnView setBackgroundImage:[UIImage imageNamed:@"Me.jpg"] forState:UIControlStateNormal];
    }
}
- (void)saveUserInfo:(NSDictionary*)dic
{
    [USER_DEFAULT setObject:dic forKey:kUserInfo];
    [USER_DEFAULT synchronize];
}
-(NSDictionary*)getUserInfo
{
    return [USER_DEFAULT objectForKey:kUserInfo];
}


-(void)updateInfoView:(NSNotification*)info
{
    NSLog(@"updateInfoView:%@",info);
    if ([info.name isEqualToString:@"updateInfo"])
    {
        NSString* nickName=[info.userInfo objectForKey:@"nickName"];
        NSString* signature=[info.userInfo objectForKey:@"signature"];
        self.infoView.nameLabel.text=nickName;
        self.infoView.signatureLabel.text=signature;
    }
    else if ([info.name isEqualToString:@"iconChange"])
    {
        //NSLog(@"url:%@",[info.userInfo objectForKey:@"iconURL2Str"]);
        NSString* iconURL2Str=[info.userInfo objectForKey:@"iconURL2Str"];
        NSURL* iconURL=[NSURL URLWithString:iconURL2Str];
        ALAssetsLibrary* assetsLib=[[ALAssetsLibrary alloc] init];
        [assetsLib assetForURL:iconURL resultBlock:^(ALAsset *asset)
        {
            UIImage* icon=[UIImage imageWithCGImage:asset.thumbnail];
            
            [self.infoView.iconBtnView setImage:icon forState:UIControlStateNormal];
            
        } failureBlock:nil];
    }

}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentCity"])
    {
        [self.infoView.locationBtn setTitle:[change valueForKey:NSKeyValueChangeNewKey] forState:UIControlStateNormal];
    }
    else if ([keyPath isEqualToString:@"nickName"])
    {
        self.infoView.nameLabel.text=[change valueForKey:NSKeyValueChangeNewKey];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:nil];
    }
}
-(void)dealloc
{
    [self.locationModel removeObserver:self forKeyPath:@"currentCity"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - MyInfoViewDelegate
-(void)editMyInfoDelegate
{
    SZEditMyInfoVC* editMyInfoVC=[[SZEditMyInfoVC alloc] init];
    self.editMyInfoVC=editMyInfoVC;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.editMyInfoVC];
    [self presentViewController:nav animated:YES completion:nil];
    //[self.navigationController pushViewController:self.editMyInfoVC animated:YES];
}
#pragma mark- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell  respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)])
    {
        [cell setPreservesSuperviewLayoutMargins:YES];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}
#pragma mark -UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        SZLoginVC* loginVC=[[SZLoginVC alloc] init];
        UINavigationController* nav=[[UINavigationController  alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
@end
