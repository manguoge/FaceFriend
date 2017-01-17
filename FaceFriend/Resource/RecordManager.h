//
//  RecordManager.h
//  CustomCamera
//
//  Created by comfouriertech on 16/8/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIApplication.h>
#import "Recorder.h"

@protocol RecordManagerDelegate;
@interface RecordManager : NSObject<RecorderDelegate>
//定义AVCaptureSession对象，管理输入设备到输出端的数据流
@property (nonatomic,retain) AVCaptureSession* session;
@property (nonatomic,assign) AVCaptureVideoOrientation orientation;
//定义捕捉视频和声音的输入设备
@property (nonatomic,retain) AVCaptureDeviceInput* videoInput;
@property (nonatomic,strong) AVCaptureDeviceInput* audioIput;
//定义输出静态照片的输出端
@property (nonatomic,retain) AVCaptureStillImageOutput* stillImageOutput;
@property (nonatomic,retain) Recorder* recorder;
@property (nonatomic,assign) id deviceConnectedObserver;
@property (nonatomic,assign) id deviceDisconnectedObserver;
@property (nonatomic,assign) UIBackgroundTaskIdentifier backgroundRecordID;
@property (nonatomic,assign) id<RecordManagerDelegate> delegate;

-(BOOL)setupSession;
-(void)starRecording;
-(void)stopRecording;
-(void)captureStillImage;
-(BOOL)toggleCamera;
-(NSInteger)cameraCount;
-(NSInteger)micCount;
-(void)autoFocusAtPoint:(CGPoint)point;
-(void)continuousFoucsAtPoint:(CGPoint)point;

@end
//定义该代理对象必须遵守的协议
@protocol RecordManagerDelegate <NSObject>
@optional
-(void)recordManager:(RecordManager*)recordManager didFailWithError:(NSError*)error;
-(void)recordManagerRecordingBegan:(RecordManager*)recordManager;
-(void)recordManagerRecordingFinished:(RecordManager*)recordManager;
-(void)recordManagerStillImageCaptured:(RecordManager *)recordManager;
-(void)recordManagerDeviceConfigurationChanged:(RecordManager *)recordManager;

@end
