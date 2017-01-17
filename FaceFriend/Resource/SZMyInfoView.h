//
//  SZIcoView.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/29.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyInfoViewDelegate
-(void)editMyInfoDelegate;
@end

@interface SZMyInfoView : UIButton
@property (nonatomic,strong) UIButton* iconBtnView;
@property (nonatomic,strong) UILabel* contactNumLabel;
@property (nonatomic,strong) UILabel* nameLabel;
@property (nonatomic,strong) UIButton* locationBtn;
@property (nonatomic,strong) UILabel* signatureLabel;
@property (nonatomic,assign) id<MyInfoViewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame icon:(UIImage*)icon name:(NSString*)name contactNum:(NSUInteger)contactNum location:(NSString*)location signature:(NSString*)signature;
@end
