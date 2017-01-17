//
//  SZCameraView.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZCameraView.h"
#import "Configure.h"
@implementation SZCameraView
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    CGRect previewFrame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-44);
    UIView* videoPreviewView=[[UIView alloc] initWithFrame:previewFrame];
    self.videoPreviewView=videoPreviewView;
    [self addSubview:self.videoPreviewView];
//    @property (weak, nonatomic) UIBarButtonItem *recordButton;
//    @property (weak, nonatomic) UIBarButtonItem *cameraToggleButton;
//    @property (weak, nonatomic) UIBarButtonItem *stillButton;
    
    CGFloat btnWidth=60;
    CGFloat btnHeigth=44;
    CGFloat margin=60;
    UIButton* recordButton=[[UIButton alloc] initWithFrame:CGRectMake(margin, frame.size.height-44, btnWidth, btnHeigth)];
    self.recordButton=recordButton;
    [self addSubview:recordButton];
    
    UIButton* cameraToggleButton=[[UIButton alloc] initWithFrame:CGRectMake(2*margin+btnWidth, frame.size.height-44, btnWidth, btnHeigth)];
    self.cameraToggleButton=cameraToggleButton;
    [self addSubview:cameraToggleButton];
    
    UIButton* stillButton=[[UIButton alloc] initWithFrame:CGRectMake(3*margin+2*btnWidth, frame.size.height-44, btnWidth, btnHeigth)];
    self.stillButton=stillButton;
    [self addSubview:stillButton];
    
    [self.recordButton addTarget:self action:toggleRecording forControlEvents:UIControlEventTouchUpInside];
    [self.cameraToggleButton addTarget:self action:toggleCamera forControlEvents:UIControlEventTouchUpInside];
    [self.stillButton addTarget:self action:captureStillImage forControlEvents:UIControlEventTouchUpInside];
    [self.cameraToggleButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [self.stillButton setTitle:@"拍照" forState:UIControlStateNormal];
    
    [self.recordButton setTitle:@"录制" forState:UIControlStateNormal];
    [self.cameraToggleButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
    [self.stillButton setTitle:@"拍照" forState:UIControlStateNormal];
    return self;
}

//为三个按钮的事件处理方法提供实现
-(void)toggleRecording:(id)sender
{
    //将该按钮切换为禁用状态
    self.recordButton.enabled=NO;
    //如果当前没有处于拍摄状态
    if (!self.recordManager.recorder.isRecording)
    {
        //开始拍摄
        [self.recordManager starRecording];
    }
    else
    {
        //停止拍摄
        [self.recordManager stopRecording];
    }
}

-(void)toggleCamera:(id)sender
{
    //切换前后摄像头
    [self.recordManager toggleCamera];
    //初始化对焦
    [self.recordManager continuousFoucsAtPoint:CGPointMake(0.5f, 0.5f)];
}

-(void)captureStillImage:(id)sender
{
    //将按钮设置为禁用状态
    self.stillButton.enabled=NO;
    //拍摄静止照片
    [self.recordManager captureStillImage];
    //创建一个UIView实现闪屏的效果
    UIView* flashView=[[UIView alloc] initWithFrame:self.videoPreviewView.frame];
    //设置背景为白色
    flashView.backgroundColor=[UIColor whiteColor];
    //添加flashView
    [self.view.window addSubview:flashView];
    //控制flashView执行在0.4秒内变成完全透明，变为透明时删除该flashView
    [UIView animateWithDuration:0.4 animations:^
     {
         [flashView setAlpha:0.0f];
     } completion:^(BOOL finished)
     {
         [flashView removeFromSuperview];
     }];
}

@end
