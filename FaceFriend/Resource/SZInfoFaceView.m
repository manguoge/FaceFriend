//
//  SZInfoFaceView.m
//  FaceFriend
//
//  Created by comfouriertech on 16/10/8.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZInfoFaceView.h"

@implementation SZInfoFaceView
-(instancetype)initWithFrame:(CGRect)frame image:(UIImage*)faceImage name:(NSString*)nickName sex:(NSString*)sex signature:(NSString*)signature
{
    if (self=[super initWithFrame:frame])
    {
        self.layer.cornerRadius=10;
        self.layer.masksToBounds=YES;
        //1.显示头像脸图片的ImageView
        CGFloat marginX=10;
        CGFloat marginY=10;
        CGFloat FaceIViewW=CGRectGetWidth(frame);
        CGFloat FaceIViewH=CGRectGetHeight(frame)-64-3*marginY;
        UIImageView* FaceIView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, FaceIViewW, FaceIViewH)];
        FaceIView.image=faceImage;
        FaceIView.layer.cornerRadius=10;
        FaceIView.layer.masksToBounds=YES;
        self.faceIView=FaceIView;
        [self addSubview:self.faceIView];
        //2.底部InfoView
        UIView* infoView=[[UIView alloc] initWithFrame:CGRectMake(0, FaceIViewH, CGRectGetWidth(frame), 64+3*marginY)];
        infoView.backgroundColor=[UIColor orangeColor];
        infoView.layer.cornerRadius=5;
        infoView.layer.masksToBounds=YES;
        [self addSubview:infoView];
        //3.昵称Label  高度44
        CGFloat nickNameLabelW=50;
        CGFloat nickNameLabelH=44;
        UILabel* nickNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(marginX, marginY, nickNameLabelW, nickNameLabelH)];
        nickNameLabel.text=nickName;
        self.nickNameLabel=nickNameLabel;
        [infoView addSubview:self.nickNameLabel];
        //4.性别imageview 20
        CGFloat sexIViewW=20;
        CGFloat sexIViewH=20;
        UIImageView* sexIView=[[UIImageView alloc] initWithFrame:CGRectMake(marginX, 2*marginY+nickNameLabelH, sexIViewW, sexIViewH)];
        if ([sex isEqualToString:@"male"])
        {
            sexIView.image=[UIImage imageNamed:@"male.jpg"];
        }
        else
        {
            sexIView.image=[UIImage imageNamed:@"female.jpg"];
        }
        self.sexIView=sexIView;
        [infoView addSubview:self.sexIView];
        //5.签名Label 20
        CGFloat signatureLabelW=CGRectGetWidth(frame)-2*marginX-sexIViewW;
        CGFloat signatureLabelH=20;
        UILabel* signatureLabel=[[UILabel alloc] initWithFrame:CGRectMake(2*marginX+sexIViewW,2*marginY+nickNameLabelH, signatureLabelW, signatureLabelH)];
        signatureLabel.text=signature;
        self.signatureLabel=signatureLabel;
        [infoView addSubview:self.signatureLabel];
        
    }
    return self;
}
-(void)updateDisplay
{
    
}
@end
