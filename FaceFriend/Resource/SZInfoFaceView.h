//
//  SZInfoFaceView.h
//  FaceFriend
//
//  Created by comfouriertech on 16/10/8.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZInfoFaceView : UIView
@property (nonatomic,strong) UIImageView* faceIView;
@property (nonatomic,strong) UILabel* nickNameLabel;
@property (nonatomic,strong) UIImageView* sexIView;
@property (nonatomic,strong) UILabel* signatureLabel;

-(instancetype)initWithFrame:(CGRect)frame image:(UIImage*)faceImage name:(NSString*)nickName sex:(NSString*)sex signature:(NSString*)signature;
-(void)updateDisplay;
@end
