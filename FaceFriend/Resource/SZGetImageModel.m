//
//  SZGetPhotoModel.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/19.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZGetImageModel.h"

@implementation SZGetImageModel

+(instancetype)defaultModel
{
    SZGetImageModel* imageModel=[[SZGetImageModel alloc] init];
    
    return imageModel;
}

//获取相册的所有图片
-(NSMutableArray*)reloadImagesFromLibrary
{
    self.images = [[NSMutableArray alloc] init];
    dispatch_queue_t globalQueue=dispatch_get_main_queue();
    dispatch_async(globalQueue, ^
    {
       // @autoreleasepool
        {
            ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
                NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
                if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                    NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
                }else{
                    NSLog(@"相册访问失败.");
                }
            };
            
            ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result, NSUInteger index, BOOL *stop){
                if (result!=NULL) {
                    
                    if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                        
                        NSString *urlstr=[NSString stringWithFormat:@"%@",result.defaultRepresentation.url];//图片的url
                        [self.images addObject:urlstr];
                        //NSLog(@"urlStr is %@",urlstr);
                        /*result.defaultRepresentation.fullScreenImage//图片的大图
                         result.thumbnail                             //图片的缩略图小图
                         //                    NSRange range1=[urlstr rangeOfString:@"id="];
                         //                    NSString *resultName=[urlstr substringFromIndex:range1.location+3];
                         //                    resultName=[resultName stringByReplacingOccurrencesOfString:@"&ext=" withString:@"."];//格式demo:123456.png
                         */
                    }
                }
            };
            
            ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group, BOOL* stop){
                
                if (group == nil)
                {
                    
                }
                
                if (group!=nil) {
                    NSString *g=[NSString stringWithFormat:@"%@",group];//获取相簿的组
                    NSLog(@"gg:%@",g);//gg:ALAssetsGroup - Name:Camera Roll, Type:Saved Photos, Assets count:71
                    
                    NSString *g1=[g substringFromIndex:16 ] ;
                    NSArray *arr=[[NSArray alloc] init];
                    arr=[g1 componentsSeparatedByString:@","];
                    NSString *g2=[[arr objectAtIndex:0] substringFromIndex:5];
                    if ([g2 isEqualToString:@"Camera Roll"]) {
                        g2=@"相机胶卷";
                    }
                    //NSString *groupName=g2;//组的name
                    
                    [group enumerateAssetsUsingBlock:groupEnumerAtion];
                }
                
            };
            
            ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
            [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:libraryGroupsEnumeration failureBlock:failureblock];
        }
        
    });
    return self.images;
}

@end
