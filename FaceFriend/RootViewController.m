//
//  ViewController.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/9.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "RootViewController.h"
#import "TencentYoutuYun/Auth.h"
#import "TencentYoutuYun/Conf.h"
#import "TencentYoutuYun/TXQcloudFrSDK.h"
#import "TencentYoutuYun/vendor/NSData+Base64.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"主页";
    [Conf instance].appId = @"10008425";
    [Conf instance].secretId = @"AKID62wSFaiPQThFW2Agh9JCNLI9ltL86jlP";
    [Conf instance].secretKey = @"c0XpmiFEimc2WtMfUk3kwbnNHfZ6qHa8";
    
    NSString *auth = [Auth appSign:1000000 userId:nil];
    TXQcloudFrSDK *sdk = [[TXQcloudFrSDK alloc] initWithName:[Conf instance].appId authorization:auth];
    
    sdk.API_END_POINT = @"http://api.youtu.qq.com/youtu";
    
    //    UIImage *local = [UIImage imageNamed:@"id.jpg"];
    UIImage *local = [UIImage imageNamed:@"id.jpg"];
    NSString *remote = @"http://a.hiphotos.baidu.com/image/pic/item/42166d224f4a20a4be2c49a992529822720ed0aa.jpg";
    id image = local;
    
        [sdk detectFace:image successBlock:^(id responseObject) {
            NSLog(@"responseObject: %@", responseObject);
        } failureBlock:^(NSError *error) {
            NSLog(@"error");
        }];
    
    [sdk idcardOcr:image cardType:0 sessionId:nil successBlock:^(id responseObject)
    {
        NSLog(@"idcardOcr: %@", responseObject);
    } failureBlock:^(NSError *error)
     {
        
    }];
    //
    [sdk namecardOcr:image sessionId:nil successBlock:^(id responseObject) {
        NSLog(@"namecardOcr: %@", responseObject);
    } failureBlock:^(NSError *error) {
        
    }];
    //    [sdk imageTag:image cookie:nil seq:nil successBlock:^(id responseObject) {
    //        NSLog(@"responseObject: %@", responseObject);
    //    } failureBlock:^(NSError *error) {
    //
    //    }];
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

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
