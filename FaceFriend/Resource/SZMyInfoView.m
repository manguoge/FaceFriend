//
//  SZIcoView.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/29.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZMyInfoView.h"

@implementation SZMyInfoView
-(instancetype)initWithFrame:(CGRect)frame icon:(UIImage*)icon name:(NSString*)name contactNum:(NSUInteger)contactNum location:(NSString*)location signature:(NSString*)signature
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundImage:[UIImage imageNamed:@"myInfoBackground.jpg"] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(editMyInfo) forControlEvents:UIControlEventTouchUpInside];
        self.layer.cornerRadius=5;
        self.layer.masksToBounds=YES;
        CGFloat totalHeight=CGRectGetHeight(frame);
        CGFloat totalWidth=CGRectGetWidth(frame);
        CGFloat marginX=10;
        CGFloat marginY=5;
        CGFloat labelWidth=100;
        CGFloat labelHeiht=30;
        CGFloat iconWidth=totalWidth/8;
        CGFloat iconHeight=iconWidth;
        
        //头像
        UIButton* iconBtnView=[[UIButton alloc] initWithFrame:CGRectMake((SCREENWIDTH-totalWidth/8)/2, marginY, iconWidth, iconHeight)];
        [iconBtnView setBackgroundImage:icon forState:UIControlStateNormal];
        [iconBtnView addTarget:self action:@selector(editMyInfo) forControlEvents:UIControlEventTouchUpInside];
        iconBtnView.layer.masksToBounds=YES;
        iconBtnView.layer.cornerRadius=iconWidth*0.5;
        self.iconBtnView=iconBtnView;
        [self addSubview:self.iconBtnView];
        //昵称
        CGFloat nameLabelX=(totalWidth-2*labelWidth-marginX)/2;
        CGFloat nameLabelY=2*marginY+iconHeight;
        UILabel* nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(nameLabelX,nameLabelY, labelWidth, labelHeiht)];
        nameLabel.textAlignment=NSTextAlignmentCenter;
        nameLabel.text=name;//昵称
        self.nameLabel=nameLabel;
        [self addSubview:self.nameLabel];
        //粉丝数量
        UILabel* contactNumLabel=[[UILabel alloc] initWithFrame:CGRectMake(totalWidth-nameLabelX-labelWidth, nameLabelY, labelWidth, labelHeiht)];
        contactNumLabel.textAlignment=NSTextAlignmentCenter;
        contactNumLabel.text=[NSString stringWithFormat:@"%@ %ld",NSLocalizedString(@"Fans", nil),contactNum];// 粉丝数量
        self.contactNumLabel=contactNumLabel;
        [self addSubview:self.contactNumLabel];
        //个性签名
        CGFloat signY=(totalHeight-marginY-labelHeiht);
        UILabel* signatureLabe=[[UILabel alloc] initWithFrame:CGRectMake(0, signY, totalWidth, labelHeiht)];
        signatureLabe.textAlignment=NSTextAlignmentCenter;
        signatureLabe.text=signature;
        self.signatureLabel=signatureLabe;
        [self addSubview:self.signatureLabel];
        //地理定位
        CGFloat btnW=80;
        CGFloat btnH=30;
        UIButton* locationBtn=[[UIButton alloc] initWithFrame:CGRectMake(totalWidth-marginX-btnW, marginY, btnW, btnH)];
        //设置背景图片、、、、、
        [locationBtn addTarget:self action:@selector(locate) forControlEvents:UIControlEventTouchUpInside];
        [locationBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [locationBtn setTitle:location forState:UIControlStateNormal];
        self.locationBtn=locationBtn;
        [self addSubview:self.locationBtn];
        
    }
    return self;
}
// 点击头像编辑我的信息,代理方法，进入编辑控制器视图
-(void)editMyInfo
{
    [self.delegate editMyInfoDelegate];
}

//定位按钮方法
-(void)locate
{
}
@end
