//
//  SZAlbumController.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZAlbumVC.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "NSDictionary+descrition.h"
#import "NSArray+descrition.h"
@interface SZAlbumVC()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,albumDataSource,UIAlertViewDelegate>
{
    CGRect scrollFrame;
    CGSize scrollSize;
}
@end

@implementation SZAlbumVC
@synthesize sdk;
@synthesize imagesURLStr;
@synthesize imageModel;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=NSLocalizedString(@"Album", nil);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19],NSFontAttributeName,[UIColor blackColor],NSForegroundColorAttributeName, nil]];

    
    ////////签名鉴权开始
    [Conf instance].appId = @"10008425";
    [Conf instance].secretId = @"AKID62wSFaiPQThFW2Agh9JCNLI9ltL86jlP";
    [Conf instance].secretKey = @"c0XpmiFEimc2WtMfUk3kwbnNHfZ6qHa8";
    NSString *auth = [Auth appSign:1000000 userId:nil];
    sdk = [[TXQcloudFrSDK alloc] initWithName:[Conf instance].appId authorization:auth];
    sdk.API_END_POINT = @"http://api.youtu.qq.com/youtu";
    //签名鉴权完成
    
    //从模型获取照片
        imageModel=[SZGetImageModel defaultModel];
        imagesURLStr = [imageModel  reloadImagesFromLibrary];
    NSLog(@"imagesURLStr.count:%ld",[imagesURLStr count]);

    //添加滚动视图
    scrollFrame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGTH);
    scrollSize=CGSizeMake(SCREENWIDTH, CGRectGetHeight(scrollFrame));//减去两个按钮等占据的高度
    SZAlbumScrollView* albumScrolleView=[[SZAlbumScrollView alloc] initWithFrame: scrollFrame contenSize:scrollSize];
    albumScrolleView.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.albumScrolleView=albumScrolleView;
    [self.view addSubview:self.albumScrolleView];
    
    //[self logImages];
    //NSUInteger btnW=100;
    //NSUInteger marginX=(SCREENWIDTH-2*btnW)/3;
    //getImageTag按钮
    UIBarButtonItem *GetTagBtn = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"GetTags", nil) style:UIBarButtonItemStylePlain target:self action:@selector(logImages)];
    [self.navigationItem setLeftBarButtonItem:GetTagBtn];
    
    //相片分类的相册按钮
    UIBarButtonItem* classifyBtn=[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Album", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addAlbumView)];
    [self.navigationItem setRightBarButtonItem:classifyBtn];
    
    //进入手机相册选照片按钮
    UIButton* pickerBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pickerBtn setFrame:CGRectMake((SCREENWIDTH-100)*0.5, 70, 100, 30)];
    [pickerBtn setTitle:NSLocalizedString(@"Album", nil) forState:UIControlStateNormal];
    [pickerBtn addTarget:self action:@selector(pickerImage) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:pickerBtn];
    UIAlertView* tipAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tip", nil) message:NSLocalizedString(@"Click 'Tag' at first,and then click 'Album'.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    [tipAlert show];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.firstAlbumView.albumIView startAnimating];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self logImages];
//    _albumCount=0;
//    dispatch_queue_t concurrentQueue=dispatch_queue_create("CONCURRENT0",DISPATCH_QUEUE_CONCURRENT);
//    dispatch_sync(concurrentQueue, ^
//    {
//        while ([self.noRepeatTags count]>=_albumCount)
//        {
//            NSLog(@"%ld",[self.noRepeatTags count]);
//            [self addAlbumView];
//        }
//    });
//    
}

-(void)addAlbumView
{
    _albumCount=[self.noRepeatTags count];//相册总数
    NSUInteger columnCount=2;//列数
    NSUInteger rowCount=(_albumCount+1)/columnCount;//行数
    NSUInteger rowNumber;//行号
    NSUInteger columnNumber;//列号
    CGFloat marginX=15;
    CGFloat marginY=15;
    CGFloat albumX;
    CGFloat albumY;
    CGFloat albumWidth=(SCREENWIDTH-(columnCount+1)*marginX)/columnCount;
    CGFloat albumHeight=albumWidth+30;//30是label的高度

    //更新albumScrollView的contenSize
    scrollSize=CGSizeMake(SCREENWIDTH, rowCount*albumHeight+(rowCount+1)*marginY+64+30);
    [self.albumScrolleView update:scrollFrame contenSize:scrollSize];
    

    for (int i=0; i<_albumCount; i++)
    {
        rowNumber=i/columnCount;
        columnNumber=i%columnCount;
        albumX=(columnNumber+1)*marginX+columnNumber*albumWidth;
        albumY=(rowNumber+1)*marginY+rowNumber*albumHeight;
        //NSLog(@"%f",albumY);
        CGRect albumFrame=CGRectMake(albumX, albumY, albumWidth, albumHeight);
        NSUInteger index=[self.tags indexOfObject:[self.noRepeatTags objectAtIndex:i]];
        
        NSURL* currentPhotoURL=[self.imageURLs objectAtIndex:index];
        //NSLog(@"url:%@",currentPhotoURL);
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:currentPhotoURL resultBlock:^(ALAsset *asset)
         {
             UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
             SZAlbumView* albumView=[[SZAlbumView alloc] initWithFrame:albumFrame AlbumName:[self.noRepeatTags objectAtIndex:i] image:image tag:i];
             albumView.delegate=self;
             [self.albumScrolleView addSubview:albumView];
             //如果是第一个相册, 使相册的视图轮播相册里面的图片
             if (i==0)
             {
                 NSString* firstAlbumTag=self.noRepeatTags[i];
                 //同一相册的使用照片URL
                 NSMutableArray* AlbumImageURLs=[[NSMutableArray alloc] init];
                 
                 for(NSUInteger  j=0;j<[self.tags count];j++)
                 {
                     NSString* imageTag=[self.tags objectAtIndex:j];
                     if ([imageTag isEqualToString:firstAlbumTag])
                     {
                         [AlbumImageURLs addObject:[self.imageURLs objectAtIndex:j]];
                     }
                 }
                 //本相册照片数量
                 NSUInteger photoNum=[AlbumImageURLs count];
                 __block NSMutableArray* images=[NSMutableArray arrayWithCapacity:photoNum];
                 for (NSUInteger i=0; i<photoNum; i++)
                 {
                     [self.assertsLibrary assetForURL:AlbumImageURLs[i] resultBlock:^(ALAsset *asset)
                      {
                          UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
                          [images addObject:image];
                          NSLog(@"images.count=%ld",[images count]);
                      } failureBlock:^(NSError *error)
                     {
                          NSLog(@"error:%@",error);
                      }];
                 }
                 NSLog(@"images.count2=%ld",[images count]);
                 //相册幻灯片播放
                 dispatch_async(dispatch_get_main_queue(), ^
                 {
                     //方便在ViewWillAppear再次开启动画
                     self.firstAlbumView=albumView;
                     self.firstAlbumView.albumIView.animationImages=images;
                     //每张照片播放0.7s
                     self.firstAlbumView.albumIView.animationDuration=photoNum*0.7;
                     self.firstAlbumView.albumIView.animationRepeatCount=100;
                     [self.firstAlbumView.albumIView startAnimating];
                     
                 });
                 
             }
             
         }failureBlock:nil];
    }
}

//getImage按钮响应方法
- (void)logImages
{
    dispatch_queue_t concurrentQueue=dispatch_queue_create("CONCURRENT",DISPATCH_QUEUE_CONCURRENT);
    //开启异步提交并行线程请求数据
    dispatch_async(concurrentQueue, ^
    {
        for (int i=0; i<imagesURLStr.count; i++)
        {
            [self getImage:[imagesURLStr objectAtIndex:i]];
        }
    });
    
}

- (void)getImage:(NSString *)urlStr
{
    ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
    self.assertsLibrary=assetLibrary;
    NSURL *currentPhotoURL=[NSURL URLWithString:urlStr];
    [assetLibrary assetForURL:currentPhotoURL resultBlock:^(ALAsset *asset)
     {
        UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
         //进入优图服务器请求图片标签
         [sdk imageTag:image cookie:nil seq:nil successBlock:^(id responseObject)
          {
              responseObject=(NSDictionary*)responseObject;
              //每张照片的标签数组
              NSArray* tagArray=[responseObject objectForKey:@"tags"];
              
              //有返回标签时，将照片放入对应的标签相册
              if ([tagArray count])
              {
                  NSDictionary* maxTag=[self maxConfidenceTag:tagArray];
                  NSString* tagName=[maxTag objectForKey:@"tag_name"];
                  //NSLog(@"successBlock:%@",[maxTag description]);
                  if (self.tags==nil)
                  {
                      self.tags=[[NSMutableArray alloc] init];
                      self.noRepeatTags=[[NSMutableArray alloc] init];
                      self.imageURLs=[[NSMutableArray alloc] init];
                      [self.tags addObject:tagName];
                      [self.noRepeatTags addObject:tagName];
                      [self.imageURLs addObject:currentPhotoURL];
                  }
                  else
                  {
                      [self.tags addObject:tagName];
                      [self.imageURLs addObject:currentPhotoURL];
                      if ([self.noRepeatTags indexOfObject:tagName]==NSNotFound)
                      {
                          [self.noRepeatTags addObject:tagName];
                      }
                  }
                  //NSLog(@"tags:%@,photoURLs:%@",self.tags,self.photoURLs);
                  
              }
              //无返回标签时，将照片放入other相册
              else
              {
                  
              }
             
          } failureBlock:^(NSError *error)
          {
              NSLog(@"failureBlock:%@",error);
          }];
         
    }failureBlock:^(NSError *error)
    {
        NSLog(@"error=%@",error);
    }];
}
//传入一张图片进入优图返回的标签数组数据，返回置信度最高的字典标签
-(NSDictionary*)maxConfidenceTag:(NSArray*)tagArray
{
    NSDictionary* maxTag=[NSDictionary dictionaryWithDictionary:[tagArray objectAtIndex:0]];
    for (NSDictionary* dict in tagArray)
    {
        if ([dict objectForKey:@"tag_confidence"]>[maxTag objectForKey:@"tag_confidence"])
        {
            maxTag=dict;
        }
    }
    return maxTag;
}


#pragma -mark albumDataSource
-(void)albumImages:(UIImageView*)albumIView;
{
    //通过点击的相册的标签记录获取对应的同一个照片标签的使用照片
    NSUInteger albumIViewTag=albumIView.tag;
    NSString* currentAlbumTag=self.noRepeatTags[albumIViewTag];
    //同一相册的使用照片URL
    NSMutableArray* AlbumImageURLs=[[NSMutableArray alloc] init];
    for(NSUInteger i=0;i<[self.tags count];i++)
    {
        NSString* imageTag=[self.tags objectAtIndex:i];
        if ([imageTag isEqualToString:currentAlbumTag])
        {
            [AlbumImageURLs addObject:[self.imageURLs objectAtIndex:i]];
        }
    }
    
    NSUInteger imageCount=[AlbumImageURLs count];//相册里照片总数
    //照片视图阵列参数
    NSUInteger columnCount=3;//列数
    NSUInteger rowCount=(imageCount+1)/columnCount;//行数
    NSUInteger rowNumber;//行号
    NSUInteger columnNumber;//列号
    CGFloat marginX=5;
    CGFloat marginY=5;
    CGFloat imageX;
    CGFloat imageY;
    CGFloat imageWidth=(SCREENWIDTH-(columnCount+1)*marginX)/columnCount;
    CGFloat imageHeight=imageWidth;
    
    self.albumPageVC=[[SZPhotoPageVC alloc] init];
    self.albumPageVC.title=[NSString stringWithFormat:@"'%@'%@",currentAlbumTag,NSLocalizedString(@"Photo", nil)];
    
    CGRect frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGTH);
    CGFloat conentHeight=marginY*(rowCount+1)+imageHeight*(rowCount+1)+marginY;
    CGSize contenSize=CGSizeMake(SCREENWIDTH, conentHeight);
    SZAlbumScrollView* albumPageScrollView=[[SZAlbumScrollView alloc] initWithFrame:frame contenSize:contenSize];
    CGPoint offset=CGPointMake(0, 0);
    albumPageScrollView.contentOffset=offset;
    albumPageScrollView.backgroundColor=[UIColor greenColor];
    [self.albumPageVC.view addSubview:albumPageScrollView];
    
    //照片视图阵列
    for (int i=0; i<imageCount; i++)
    {
        rowNumber=i/columnCount;
        columnNumber=i%columnCount;
        imageX=(columnNumber+1)*marginX+columnNumber*imageWidth;
        imageY=(rowNumber+1)*marginY+rowNumber*imageHeight;
        CGRect albumFrame=CGRectMake(imageX, imageY, imageWidth, imageHeight);
        

        [self.assertsLibrary assetForURL:AlbumImageURLs[i] resultBlock:^(ALAsset *asset)
        {
            UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
            UIImageView* imageView=[[UIImageView alloc] initWithFrame:albumFrame];
            imageView.image=image;
            imageView.backgroundColor=[UIColor whiteColor];
            [albumPageScrollView addSubview:imageView];
        } failureBlock:^(NSError *error)
        {
            
        }];
        
    }

    UINavigationController* nav=[[UINavigationController alloc] initWithRootViewController:self.albumPageVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)pickerImage
{
    //添加照片拾取器
    //NSLog(@"pickerImage");
    UIImagePickerController* imagePickerVC=[[UIImagePickerController alloc] init];
    imagePickerVC.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePickerVC.view.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGTH-44);
    imagePickerVC.delegate=self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

#pragma -mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // NSLog(@"imagePickerController:%@",info);
    
    NSString* mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage* image=nil;
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage])
    {
        if ([picker allowsEditing])
        {
            image=[info objectForKey:UIImagePickerControllerEditedImage];
        }
        else
        {
            image=[info objectForKey:UIImagePickerControllerOriginalImage];
        }
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        self.image=image;
        //进入优图服务器请求图片标签
        [sdk imageTag:image cookie:nil seq:nil successBlock:^(id responseObject)
         {
             //NSLog(@"successBlock:%@",responseObject);
         } failureBlock:^(NSError *error)
         {
             NSLog(@"failureBlock:%@",error);
         }];
    }
    //
    else if ([mediaType isEqualToString:(NSString*)kUTTypeMovie])
    {
        NSURL* mediaURL=[info objectForKey:UIImagePickerControllerMediaURL];
        ALAssetsLibrary* assetsLibrary=[[ALAssetsLibrary alloc]
                                        init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:nil];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"用户取消拍摄");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
