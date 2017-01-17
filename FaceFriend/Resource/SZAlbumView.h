//
//  SZAlbum.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/21.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol albumDataSource
//相册按钮代理协议
-(void)albumImages:(UIImageView*)albumIView;;
@end
@interface SZAlbumView: UIView
@property (nonatomic,strong) UIImageView* albumIView;
@property (nonatomic,strong) UILabel* nameLable;
@property (nonatomic,assign) id<albumDataSource> delegate;
-(instancetype)initWithFrame:(CGRect)frame  AlbumName:(NSString*)albumName image:(UIImage*)image tag:(NSUInteger)tag;
-(void)enterAlbum:(UITapGestureRecognizer*)tapGesture;;
@end
