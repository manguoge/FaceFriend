//
//  SZCameraView.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZCameraView : UIView
@property (weak, nonatomic) UIView *videoPreviewView;

@property (weak, nonatomic) UIButton *recordButton;
@property (weak, nonatomic) UIButton *cameraToggleButton;
@property (weak, nonatomic) UIButton *stillButton;
-(void)toggleRecording:(id)sender;
-(void)toggleCamera:(id)sender;
-(void)captureStillImage:(id)sender;
@end
