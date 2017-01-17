//
//  AppDelegate.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/9.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "FaceFriendAppDelegate.h"
#import "SZFaceFriendVC.h"
#import "SZPhotoGraphVC.h"
#import "SZAlbumVC.h"
#import "SZMeVC.h"
#import "SZTabBarVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <RongIMKit/RongIMKit.h>
@interface FaceFriendAppDelegate ()
@end

@implementation FaceFriendAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    //设置状态栏的字体颜色模式
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    //设置状态栏是否隐藏
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    //设置导航栏颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    
//    SZFaceFriendVC* faceFriendController=[[SZFaceFriendVC alloc] init];
//    faceFriendController.tabBarItem.title=NSLocalizedString(@"FaceFriend", nil);
//    SZPhotoGraphVC* photoGraphController=[[SZPhotoGraphVC alloc] init];
////    faceFriendController.tabBarItem.image=[UIImage imageNamed:@"FaceFriend.jpg"];
////    faceFriendController.tabBarItem.selectedImage=[UIImage imageNamed:@"FaceFriend.jpg"];
//    photoGraphController.tabBarItem.title=NSLocalizedString(@"TakePhoto", nil);
//    SZAlbumVC* albumController=[[SZAlbumVC alloc] init];
//    albumController.tabBarItem.title=NSLocalizedString(@"Album", nil);
//    SZMeVC* meController=[[SZMeVC alloc] init];
//    meController.tabBarItem.title=NSLocalizedString(@"Me", nil);
//    NSArray* controllerArray=[NSArray arrayWithObjects:faceFriendController,photoGraphController,albumController,meController, nil];
//    UITabBarController* mainBarTabController=[[UITabBarController alloc] init];
//    mainBarTabController.viewControllers=controllerArray;
//    //设置导航条隐藏与否
//    mainBarTabController.navigationController.navigationBarHidden=NO;
//    
//    UINavigationController* navigationController=[[UINavigationController alloc] initWithRootViewController:mainBarTabController];
//    //设置导航条隐藏与否
//    navigationController.navigationBarHidden = NO;
    
    SZTabBarVC* tabBarRootVC=[[SZTabBarVC alloc] initTabBar];
    self.window.rootViewController = tabBarRootVC;
    [self.window makeKeyAndVisible];
    
    ////////签名鉴权开始
    [Conf instance].appId = @"10008425";
    [Conf instance].secretId = @"AKID62wSFaiPQThFW2Agh9JCNLI9ltL86jlP";
    [Conf instance].secretKey = @"c0XpmiFEimc2WtMfUk3kwbnNHfZ6qHa8";
    NSString *auth = [Auth appSign:1000000 userId:nil];
    TXQcloudFrSDK *sdk = [[TXQcloudFrSDK alloc] initWithName:[Conf instance].appId authorization:auth];
    sdk.API_END_POINT = @"http://api.youtu.qq.com/youtu";
    //////签名鉴权完成
    
    //    UIImage *local = [UIImage imageNamed:@"id.jpg"];
    UIImage *local = [UIImage imageNamed:@"namecard.jpg"];
    //NSString *remote = @"http://a.hiphotos.baidu.com/image/pic/item/42166d224f4a20a4be2c49a992529822720ed0aa.jpg";
    //id image = local;
    
//    [sdk detectFace:image successBlock:^(id responseObject) {
//        NSLog(@"responseObject: %@", responseObject);
//    } failureBlock:^(NSError *error)
//     {
//        NSLog(@"error");
//    }];
//    
//    [sdk idcardOcr:image cardType:0 sessionId:nil successBlock:^(id responseObject)
//     {
//         NSLog(@"idcardOcr: %@", responseObject);
//     } failureBlock:^(NSError *error)
//     {
//         
//     }];
//    //
//    [sdk namecardOcr:image sessionId:nil successBlock:^(id responseObject) {
//        NSLog(@"namecardOcr: %@", responseObject);
//    } failureBlock:^(NSError *error) {
//        
//    }];
//        [sdk imageTag:image cookie:nil seq:nil successBlock:^(id responseObject)
//         {
//            NSLog(@"responseObject: %@", responseObject);
//        } failureBlock:^(NSError *error){
//    
//        }];
    //
    //    [sdk imagePorn:image cookie:nil seq:nil successBlock:^(id responseObject) {
    //        NSLog(@"responseObject: %@", responseObject);
    //    } failureBlock:^(NSError *error) {
    //
    //    }];
    //
    //    [sdk foodDetect:image cookie:nil seq:nil successBlock:^(id responseObject) {
    //        NSLog(@"responseObject: %@", responseObject);
    //    } failureBlock:^(NSError *error) {
    //
    //    }];
    //    [sdk fuzzyDetect:image cookie:nil seq:nil successBlock:^(id responseObject) {
    //        NSLog(@"responseObject: %@", responseObject);
    //    } failureBlock:^(NSError *error) {
    //
    //    }];

  
    //打开/关闭调试日志
    [[UMSocialManager defaultManager] openLog:NO];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"57eb985467e58eb69a00062c"];
    // 获取友盟social版本号
    //NSLog(@"UMeng social version: %@", [UMSocialGlobal umSocialSDKVersion]);
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"202268386"  appSecret:@"59ac1235fff7840316a2f6f56b351c84" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //融云即时通讯SDK
    [[RCIM sharedRCIM] initWithAppKey:@"82hegw5uh8qux"];
    [[RCIM sharedRCIM] connectWithToken:@"06FWwhQ9ZOapWGxe+Yxy8sZqP8UpFdRiA8NO5hc/rmHROnP8SSYyPtIUPzOAWu4TKaFUxxWh3gN8aA1GJnGwvQ==" success:^(NSString *userId)
    {
        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
    } error:^(RCConnectErrorCode status)
    {
        NSLog(@"登陆的错误码为:%ld", (long)status);
    } tokenIncorrect:^
    {
        //token过期或者不正确。
        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
        NSLog(@"token错误");
    }];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result)
    {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.hitszcerc.FaceFriend" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FaceFriend" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FaceFriend.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
