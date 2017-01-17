//
//  SZTabBarVC.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/27.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZTabBarVC.h"
#import "SZFaceFriendVC.h"
#import "SZPhotoGraphVC.h"
#import "SZAlbumVC.h"
#import "SZMeVC.h"
@implementation SZTabBarVC
-(void)viewDidLoad
{
    [super viewDidLoad];
    /*
     //    初始化主页
     HomePageViewController *homePage = [[HomePageViewController alloc]init];
     UINavigationController *homePageNav = [[UINavigationController alloc]initWithRootViewController:homePage];
     // 设置主页-TabBar
     UITabBarItem *itemHomePage= [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageWithImage:[UIImage imageNamed:@"1-1.png"] scaledToSize:CGSizeMake(25, 25)] tag:0];
     [itemHomePage setFinishedSelectedImage:[UIImage imageWithImage:[UIImage imageNamed:@"1-1.jpg"] scaledToSize:CGSizeMake(25, 25)] withFinishedUnselectedImage:[UIImage imageWithImage:[UIImage imageNamed:@"1-2.jpg"] scaledToSize:CGSizeMake(25, 25)]];
     homePageNav.tabBarItem=itemHomePage;
     [itemHomePage setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:NAVBACKGROUNDCOLOR,UITextAttributeTextColor, nil] forState:UIControlStateSelected];
     homePageNav.navigationBar.translucent = NO;
     
     */
    //[self initTabBar];

}

-(instancetype)initTabBar
{
    if (!self)
    {
        self=[super init];
    }
    SZFaceFriendVC* faceFriendVC=[[SZFaceFriendVC alloc] init];
    UINavigationController* faceFriendNav=[[UINavigationController alloc] initWithRootViewController:faceFriendVC];
    UITabBarItem* faceFriendItem=[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"FaceFriend", nil) image:nil tag:0];
    faceFriendNav.tabBarItem=faceFriendItem;
    faceFriendNav.navigationBar.translucent = NO;
    
    SZPhotoGraphVC* photoGraphVC=[[SZPhotoGraphVC alloc] init];
    UINavigationController* photoGraphNav=[[UINavigationController alloc] initWithRootViewController:photoGraphVC];
    UITabBarItem* photoGraphItem=[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"TakePhoto", nil) image:nil tag:0];
    photoGraphNav.tabBarItem=photoGraphItem;
    photoGraphNav.navigationBar.translucent = NO;
    
    SZAlbumVC* albumVC=[[SZAlbumVC alloc] init];
    UINavigationController* albumNav=[[UINavigationController alloc] initWithRootViewController:albumVC];
    UITabBarItem* albumItem=[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Album", nil) image:nil tag:0];
    albumNav.tabBarItem=albumItem;
    albumNav.navigationBar.translucent = NO;
    
    SZMeVC* meVC=[[SZMeVC alloc] init];
    UINavigationController* meNav=[[UINavigationController alloc] initWithRootViewController:meVC];
    UITabBarItem* meItem=[[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Me", nil) image:nil tag:0];
    meNav.tabBarItem=meItem;
    meNav.navigationBar.translucent = NO;


    //[[UITabBar appearance] setBackgroundImage:[UIImage setBackgroundImageByColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1] withFrame:CGRectMake(0, 0, SCREENWIDTH, 44)]];
    // 设置UITabBar背景图片
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageWithTint:COLOR(235, 235, 235, 1)]];
    self.viewControllers = [NSArray arrayWithObjects:faceFriendNav,photoGraphNav,albumNav,meNav, nil];
    return self;

}
@end
