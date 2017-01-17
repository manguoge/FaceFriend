//
//  SZAlbumScrollView.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/11.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZAlbumScrollView.h"
#import "Configure.h"
@implementation SZAlbumScrollView
-(instancetype)initWithFrame:(CGRect)frame contenSize:(CGSize)size
{
    self=[super initWithFrame:frame];
    self.contentSize=size;
    //self.showsVerticalScrollIndicator=NO;
    self.showsHorizontalScrollIndicator=NO;
    
    return self;
}
-(instancetype)update:(CGRect)frame contenSize:(CGSize)size
{
    if (self!=nil)
    {
        self.frame=frame;
        self.contentSize=size;
        //NSLog(@"update");
        return self;
    }
    else
    {
        //NSLog(@"updateelse");
        return [self initWithFrame:frame contenSize:size];
    }
}




@end
