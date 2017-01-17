//
//  ViewController.m
//  CustomCamera
//
//  Created by comfouriertech on 16/8/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "ViewController.h"
static void* AVCamFocusModeObserverContext=&AVCamFocusModeObserverContext;
@interface ViewController(RecordManagerDelegate) <RecordManagerDelegate>

@end

@implementation ViewController
AVCaptureVideoPreviewLayer* previewLayer;
UILabel* focusModeLabel;
//定义一个方法，将对焦模式转换为字符串
-(NSString*)stringForFoucsMode:(AVCaptureFocusMode)focusMode
{
    NSString* focusString=@"";
    switch (focusMode)
    {
        case AVCaptureFocusModeLocked:
            focusString=@"锁定";
            break;
        case AVCaptureFocusModeAutoFocus:
            focusString=@"自动对焦";
            break;
        case AVCaptureFocusModeContinuousAutoFocus:
            focusString=@"连续对焦";
            break;
        default:
            break;
    }
    return focusString;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.recordButton.title=@"拍摄视频";
    self.cameraToggleButton.title=@"切换摄像头";
    self.stillButton.title=@"拍照";
    //如果没有初始化RecordManager,则初始化
    if (self.recordManager==nil)
    {
        self.recordManager=[[RecordManager alloc] init];
        self.recordManager.delegate=self;
        //为RecorderManager安装Session
        if ([self.recordManager setupSession])
        {
            [self.videoPreviewView.layer setMasksToBounds:YES];
            //创建摄像头预览的layer
            previewLayer=[[AVCaptureVideoPreviewLayer alloc] initWithSession:self.recordManager.session];
            //获取当前视图控制器的view的bounds
            CGRect bounds=self.view.bounds;
            //  设置预览layer的大小和位置
            previewLayer.frame=bounds;
            //设置预览的缩放方式
            [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
            //将预览layer添加到UIView上
            [self.videoPreviewView.layer insertSublayer:previewLayer below:[[self.videoPreviewView.layer sublayers] objectAtIndex:0]];
            //以异步的方式启动RecorderManager内包装的AVCaptureSession
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                [self.recordManager.session startRunning];
            });
            [self updateButtonStates];
            //创建显示对焦模式的UILabel
            focusModeLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, bounds.size.width-20, 20)];
            focusModeLabel.backgroundColor=[UIColor clearColor];
            focusModeLabel.textColor=[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
            //获取对焦模式
            AVCaptureFocusMode initialFocusMode=self.recordManager.videoInput.device.focusMode;
            focusModeLabel.text=[NSString stringWithFormat:@"对焦：%@",[self stringForFoucsMode:initialFocusMode]];
            [self.videoPreviewView addSubview:focusModeLabel];
            //监听对焦模式的改变
            [self addObserver:self forKeyPath:@"recordManager.videoInput.device.focusMode" options:NSKeyValueObservingOptionNew context:AVCamFocusModeObserverContext];
            //添加单击手势检查器，当用户单击预览UIView时，切换为自动对焦
            UITapGestureRecognizer* singleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAutoFocus:)];
            [singleTap setNumberOfTapsRequired:1];
            [self.videoPreviewView addGestureRecognizer:singleTap];
            //添加双击手势检查器，当用户双击预览UIView时，切换为连续对焦
            UITapGestureRecognizer* doubleTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToContinosAutoFocus:)];
            [doubleTap setNumberOfTapsRequired:2];
            [self.videoPreviewView addGestureRecognizer:doubleTap];
        }
    }
}

//监听对焦方式改变的方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context==AVCamFocusModeObserverContext)
    {
        //根据对焦模式更新focusModeLabel文本
        NSLog(@"change:%@",[change objectForKey:NSKeyValueChangeNewKey]);
        [focusModeLabel setText:[NSString stringWithFormat:@"对焦：%@",[self stringForFoucsMode:(AVCaptureFocusMode)[[change objectForKey:NSKeyValueChangeNewKey]integerValue]]]];
    }
}

//为三个按钮的事件处理方法提供实现
- (IBAction)toggleRecording:(id)sender
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

- (IBAction)toggleCamera:(id)sender
{
    //切换前后摄像头
    [self.recordManager toggleCamera];
    //初始化对焦
    [self.recordManager continuousFoucsAtPoint:CGPointMake(0.5f, 0.5f)];
}

- (IBAction)captureStillImage:(id)sender
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

//当屏幕旋转时自动激发该方法，该方法重新调整PreViewLayer的大小和位置
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //根据屏幕方向对预览layer进行旋转，保证预览画面总与拍照画面一致
    switch (toInterfaceOrientation)
    {
        case UIInterfaceOrientationLandscapeLeft:
            previewLayer.affineTransform=CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeRight:
            previewLayer.affineTransform=CGAffineTransformMakeRotation(M_PI*3/2);
            break;
        case UIInterfaceOrientationPortrait:
            previewLayer.affineTransform=CGAffineTransformIdentity;
            break;
        default:
            break;
    }
    NSLog(@"根据屏幕方向对预览layer进行旋转，保证预览画面总与拍照画面一致");
    previewLayer.frame=self.view.frame;
}

// 将预览UIView上坐标系统转换为摄像头的摄像头的坐标系统。
// 在摄像头坐标系统中， {0,0}代表图片的左上角，{1,1}代表右下角
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    // 获取预览Layer的大小和位置
    CGSize frameSize = [[self videoPreviewView] frame].size;
    
    if ([previewLayer.videoGravity isEqualToString:AVLayerVideoGravityResize])
    {
        // 对X、Y坐标进行缩放，并执行反转
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height,
                                      1.0f - (viewCoordinates.x / frameSize.width));
    }
    else
    {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in self.recordManager.videoInput.ports)
        {
            if ([port mediaType] == AVMediaTypeVideo)
            {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture
                ([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                if ([previewLayer.videoGravity isEqualToString:
                     AVLayerVideoGravityResizeAspect])
                {
                    if (viewRatio > apertureRatio)
                    {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if (point.x >= blackBar && point.x <= blackBar + x2)
                        {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    }
                    else
                    {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if (point.y >= blackBar && point.y <= blackBar + y2)
                        {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                }
                else if([previewLayer.videoGravity isEqualToString:
                         AVLayerVideoGravityResizeAspectFill])
                {
                    // 对X、Y坐标进行缩放，并执行反转
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width
                                                           / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    }
                    else
                    {
                        CGFloat x2 = apertureSize.height * (frameSize.height
                                                            / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                }
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    return pointOfInterest;
}

//处理自动对焦的方法，该方法会自动对焦到某个点
-(void)tapToAutoFocus:(UITapGestureRecognizer*)singleTap
{
    if ([[[self.recordManager videoInput] device] isFocusPointOfInterestSupported])
    {
        //获取用户点击的店
        CGPoint tapPoint=[singleTap locationInView:self.videoPreviewView];
        //将用户点击的点的坐标，转化为摄像头预览控件内的坐标
        CGPoint convertedFocusPoint=[self convertToPointOfInterestFromViewCoordinates:tapPoint];
        //设置自动对焦
        [self.recordManager autoFocusAtPoint:convertedFocusPoint];
    }
}
//处理连续自动对焦
-(void)tapToContinosAutoFocus:(UITapGestureRecognizer*)doubleTap
{
    if ([[[self.recordManager videoInput] device] isFocusPointOfInterestSupported])
    {
        [self.recordManager continuousFoucsAtPoint:CGPointMake(0.5f, 0.5f)];
    }
}
//该方法根据可用的摄像头、麦克风个数来更新三个按钮的状态
-(void)updateButtonStates
{
    //获取摄像头的个数
    NSUInteger cameraCount=self.recordManager.cameraCount;
    //获取麦克风个数
    NSUInteger micCount=self.recordManager.micCount;
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^{
        //如果摄像头的个数小于2
        if (cameraCount<2)
        {
            //将切换摄像头按钮设置为禁用状态
            self.cameraToggleButton.enabled=NO;
            if (cameraCount<1)
            {
                //将拍摄照片按钮设置为禁用状态
                self.stillButton.enabled=NO;
                //如果麦克风个数小于1
                if (micCount<1)
                {
                    self.recordButton.enabled=NO;
                }
                else
                {
                    self.recordButton.enabled=YES;
                }
            }
            else
            {
                self.stillButton.enabled=YES;
                self.recordButton.enabled=YES;
            }
        }
        else
        {
            self.stillButton.enabled=YES;
            self.recordButton.enabled=YES;
            self.cameraToggleButton.enabled=YES;
        }
    });
}

@end

@implementation ViewController (RecordManagerDelegate)
//拍照或者录制视频出错时调用的方法
- (void)captureManager:(RecordManager *)recordManager didFailWithError:(NSError *)error
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void)
    {
    // 使用UIAlertView显示错误信息
       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[error localizedDescription]message:[error localizedFailureReason]delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    });
}

// 当用户开始拍摄时激发该方法
- (void)recordManagerRecordingBegan:(RecordManager *)recordManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void)
                          {
                              // 将拍摄视频的按钮的文本改为“停止”，并将状态改为可用状态
                              self.recordButton.title = @"停止拍摄";
                              self.recordButton.enabled = YES;
                          });
}
// 当用户停止拍摄时激发该方法
- (void)recordManagerRecordingFinished:(RecordManager *)recordManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void)
                          {
                              // 将recordButton按钮的文本改为“拍摄视频”，并将状态改为可用状态
                              self.recordButton.title = @"拍摄视频";
                              self.recordButton.enabled = YES;
                          });
}
// 当用户拍照时激发该方法
- (void)recordManagerStillImageCaptured:(RecordManager *)recordManager
{
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes ,^(void)
                          {
                              [[self stillButton] setEnabled:YES];
                          });
}
// 当设备的配置发生改变时，调用updateButtonStates方法更改底部按钮的状态
- (void)recordManagerDeviceConfigurationChanged:(RecordManager *)recordManager
{
    [self updateButtonStates];
}

@end
