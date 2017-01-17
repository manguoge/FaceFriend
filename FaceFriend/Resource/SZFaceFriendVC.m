//
//  SZFaceFriend.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZFaceFriendVC.h"
@interface SZFaceFriendVC()
{
    //
    CGFloat infoFaceViewW;
    CGFloat infoFaceViewH;
    //开始与结束触点的位置
    CGFloat startX,endX,startY,endY;
    //原始的图片中心
    CGFloat initCenterX,initCenterY;
    //预先加载的联系人数量
    NSUInteger FriendNum;
    NSUInteger index;
}
@end
@implementation SZFaceFriendVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    //为脸图片添加拖动手势处理
    UIPanGestureRecognizer* panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panFaceProcess:)];
    panGesture.minimumNumberOfTouches=1;
    panGesture.maximumNumberOfTouches=2;
    self.infoFaceView.userInteractionEnabled=YES;
    self.panGesture=panGesture;
    [self.infoFaceView addGestureRecognizer:self.panGesture];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil]];
    //1.自定义导航条的title视图
    UILabel *titleTextLabel = [[UILabel alloc] initWithFrame: CGRectMake((SCREENWIDTH-120)/2, 0, 120, 50)];
    titleTextLabel.backgroundColor = [UIColor clearColor];
    titleTextLabel.textColor=[UIColor blackColor];
    titleTextLabel.textAlignment=NSTextAlignmentCenter;
    [titleTextLabel setFont:[UIFont systemFontOfSize:19.0]];
    [titleTextLabel setText:NSLocalizedString(@"FaceFriend", nil)];
    self.navigationItem.titleView=titleTextLabel;
    //2.导航条获取联系人列表左按钮
    UIBarButtonItem* contactsBtn=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Chat", nil) style:UIBarButtonItemStylePlain target:self action:@selector(enterList)];
    self.navigationItem.leftBarButtonItem=contactsBtn;
    //3.导航条进入朋友圈右按钮
    UIBarButtonItem* friendCircleBtn=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"FriendCircle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(enterChat)];
    self.navigationItem.rightBarButtonItem=friendCircleBtn;
    
    //
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
}
-(void)initUI
{
    //4.
    infoFaceViewW=SCREENWIDTH-20;
    infoFaceViewH=SCREENWIDTH-20+94;
    FriendNum=3;
    index=2;
    self.infoFaceViewArray=[NSMutableArray arrayWithCapacity:FriendNum];
    self.facesArray=[[NSArray alloc] initWithObjects:@"face1.jpg",@"face2.jpg",@"face3.jpg", nil];
    for (NSUInteger i=0; i<FriendNum; i++)
    {
        //网络请求获取推荐人的信息
        SZFriendInfoModel* friendInfoModel=[[SZFriendInfoModel alloc] initWithFace:[UIImage imageNamed:[self.facesArray objectAtIndex:i]] name:@"Andy" sex:@"female" signature:[NSString stringWithFormat:@"aceFriend is a good APP! %ld",i]];
        
        SZInfoFaceView* infoFaceView=[[SZInfoFaceView alloc] initWithFrame:CGRectMake(10, 10,infoFaceViewW , infoFaceViewH)image:friendInfoModel.faceImage name:friendInfoModel.nickName sex:friendInfoModel.sex signature:friendInfoModel.signature];
        [self.infoFaceViewArray addObject:infoFaceView];
        [self.view addSubview:[self.infoFaceViewArray lastObject]];
        
    }
    self.infoFaceView=[self.infoFaceViewArray lastObject];
    
    //6.底部likeOrNoView
    CGFloat likeOrNoViewY=infoFaceViewH+10;
    CGFloat likeOrNoViewH=SCREENHEIGTH-likeOrNoViewY-44-64;
    //NSLog(@"likeOrNoViewH:%f",likeOrNoViewH);
    UIView* likeOrNoView=[[UIView alloc] initWithFrame:CGRectMake(0,likeOrNoViewY, SCREENWIDTH,likeOrNoViewH)];
    likeOrNoView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"likeOrNo.jpg"]];
    [self.view addSubview:likeOrNoView];
    //7.喜欢及不喜欢按钮
    CGFloat margin=50;
    CGFloat marginY=15;
    CGFloat btnH=likeOrNoViewH-2*marginY;
    CGFloat btnW=btnH;
    CGFloat marginX=(SCREENWIDTH-2*btnW-margin)*0.5;
    UIButton* unLikeBtn=[[UIButton alloc] initWithFrame:CGRectMake(marginX, marginY, btnW, btnH)];
    [unLikeBtn setBackgroundImage:[UIImage imageNamed:@"unLike.jpg"] forState:UIControlStateNormal];
    [likeOrNoView addSubview:unLikeBtn];
    UIButton* LikeBtn=[[UIButton alloc] initWithFrame:CGRectMake(marginX+btnW+margin, marginY, btnW, btnH)];
    [LikeBtn setBackgroundImage:[UIImage imageNamed:@"like.jpg"] forState:UIControlStateNormal];
    [likeOrNoView addSubview:LikeBtn];

}
//拖动脸图片处理方法
-(void)panFaceProcess:(UIPanGestureRecognizer*)panGesture
{
    if (panGesture.state==UIGestureRecognizerStateBegan)
    {
        //记录开始的触电位置
        startX=[panGesture locationInView:self.view].x;
        startY=[panGesture locationInView:self.view].y;
        //记录原始的图片中心
        initCenterX=panGesture.view.center.x;
        initCenterY=panGesture.view.center.y;
    }
    CGFloat translationX=[panGesture translationInView:self.view].x;
    CGFloat translationY=[panGesture translationInView:self.view].y;
    panGesture.view.center=CGPointMake(panGesture.view.center.x+translationX, panGesture.view.center.y+translationY);
    [panGesture setTranslation:CGPointZero inView:self.view];
    //添加滑移效果
    if (panGesture.state==UIGestureRecognizerStateEnded)
    {
        CGFloat velocityX=[panGesture velocityInView:self.view].x;
        CGFloat velocityY=[panGesture velocityInView:self.view].y;
        //1. 计算速度向量的长度
        CGFloat magnitude = sqrtf((velocityX * velocityX) + (velocityY * velocityY));
        //2.如果速度向量小于200，那就会得到一个小于1的小数，那么滑行会很短
        CGFloat slideMult = magnitude / 200;
        //3.基于速度和速度因素计算一个终点//返回原位置
        float slideFactor = 0.03 * slideMult;
        
        //如果手势结束并且图片移动的距离大于阈值时，移除本图片View，并显示下一张
        endX=[panGesture locationInView:self.view].x;
        endY=[panGesture locationInView:self.view].y;
        CGFloat totalTranslation=sqrtf(powf((endX-startX), 2)+powf((endY-startY), 2));
        //NSLog(@"slideFactor%F,velocityX=%f,startX=%f,endX=%f,totalTranslation:%f",slideFactor,velocityX,startX,endX,totalTranslation);
        if (totalTranslation>150)
        {
            // 放大速度，手势速度越快，消失越快
            CGPoint finalPoint=CGPointMake(panGesture.view.center.x+velocityX*10, panGesture.view.center.y+velocityY*10);
            
            //动画移除本图片View
            [UIView animateWithDuration:0.5 animations:^
            {
                panGesture.view.center=finalPoint;
            } completion:^(BOOL finished)
             {
                 [self.infoFaceView removeFromSuperview];
                 for (int i=FriendNum-1; i>=0; i--)
                 {
                     if (i>0)
                     {
                         [self.infoFaceViewArray setObject:[self.infoFaceViewArray objectAtIndex:i-1] atIndexedSubscript:i];
                     }
                     else
                     {
                         //网络请求获取推荐人的信息
                         SZFriendInfoModel* friendInfoModel=[[SZFriendInfoModel alloc] initWithFace:[UIImage imageNamed:[self.facesArray objectAtIndex:(index++)%FriendNum]] name:@"Andy" sex:@"female" signature:[NSString stringWithFormat:@"aceFriend is a good APP! %ld",(index++)%FriendNum]];
                         SZInfoFaceView* infoFaceView=[[SZInfoFaceView alloc] initWithFrame:CGRectMake(10, 10,infoFaceViewW , infoFaceViewH)image:friendInfoModel.faceImage name:friendInfoModel.nickName sex:friendInfoModel.sex signature:friendInfoModel.signature];
                         [self.infoFaceViewArray setObject:infoFaceView atIndexedSubscript:i];
                     }
                 }
                 self.infoFaceView=[self.infoFaceViewArray lastObject];
                 [self.view addSubview:self.infoFaceView];
                 [self.infoFaceView addGestureRecognizer:self.panGesture];
             }];
        }
        //如果没有移除，则显示滑移效果返回原位置
        else
        {
            CGPoint finalPoint = CGPointMake(initCenterX,initCenterY);
            //5.使用UIView动画使view滑动到终点
            [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 panGesture.view.center = finalPoint;
             } completion:nil];
        }
    }
}
//导航条获取联系人列表左按钮方法
-(void)enterChat
{
    //新建一个聊天会话View Controller对象
    RCConversationViewController *chatVC = [[RCConversationViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chatVC.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chatVC.targetId = @"targetIdYouWillChatIn";
    //设置聊天会话界面要显示的标题
    chatVC.title = @"会话标题";
    chatVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:chatVC];
    //显示聊天会话界面
    [self presentViewController:nav animated:YES completion:nil];
}
//
-(void)enterList
{
    SZConversationListVC* conversationListVC=[[SZConversationListVC alloc] init];
    UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:conversationListVC];
    conversationListVC.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    conversationListVC.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Contacts", nil) style:UIBarButtonItemStylePlain target:self action:@selector(enterContacts)];
    //显示聊天会话界面
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)enterContacts
{
    NSLog(@"enterContacts");
}

//导航条进入朋友圈右按钮
-(void)enterFriendCircle
{
    NSLog(@"enterFriendCircle");
}
-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
