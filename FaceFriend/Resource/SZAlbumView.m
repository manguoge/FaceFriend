//
//  SZAlbum.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/21.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZAlbumView.h"

@implementation SZAlbumView
-(instancetype)initWithFrame:(CGRect)frame  AlbumName:(NSString*)albumName image:(UIImage*)image tag:(NSUInteger)tag
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor greenColor];
        //1.照片ImageView
        UIImageView* albumIView=[[UIImageView alloc] init];
        albumIView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height-30);
        //像素低的原因
        albumIView.image=image;
        albumIView.tag=tag;
        albumIView.userInteractionEnabled=YES;
        albumIView.multipleTouchEnabled=YES;
        self.albumIView=albumIView;
        UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAlbum:)];
        tapGesture.numberOfTapsRequired=1;
        tapGesture.numberOfTouchesRequired=1;
        [self.albumIView addGestureRecognizer:tapGesture];
        [self addSubview:self.albumIView];
        //2.标签Label
        UILabel* nameLable=[[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height-30, frame.size.width, 30)];
        nameLable.backgroundColor=[UIColor whiteColor];
        nameLable.textAlignment=NSTextAlignmentCenter;
        [nameLable setTextColor:[UIColor blackColor]];
        nameLable.text=albumName;
        //NSLog(@"nameLable.text:%@",albumName);
        self.nameLable=nameLable;
        [self addSubview:self.nameLable];
    }
    return self;
}

-(void)enterAlbum:(UITapGestureRecognizer*)tapGesture
{
    //
    NSLog(@"enterAlbum");
    [self.delegate albumImages:[tapGesture view]];
    //albumPageVC.delegate
}
@end
