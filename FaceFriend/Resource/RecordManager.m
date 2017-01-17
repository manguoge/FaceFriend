//
//  RecordManager.m
//  CustomCamera
//
//  Created by comfouriertech on 16/8/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "RecordManager.h"
#import "RecordUtils.h"
#import <UIKit/UIDevice.h>
#import <UIKit/UIApplication.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <UIKit/UIImage.h>
@interface RecordManager(internalUtilityMethods)
-(void)deviceOrientationDidChange;
-(AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position;
-(AVCaptureDevice*)frontFacingCamera;
-(AVCaptureDevice*)backFacingCamera;
-(AVCaptureDevice*)audioDevice;
-(NSURL*)tempFileURL;
-(void)removeFile:(NSURL*)FileURL;
-(void)CopyFileToDocument:(NSURL*)fileURL;
@end

@implementation RecordManager
-(id)init
{
    self=[super init];
    if (self)
    {
        __block id weakSelf=self;
        //定义输入设备连接时执行的代码块
        void (^deviceConnectedBlock)(NSNotification*)=
        ^(NSNotification *notification)
        {
            NSLog(@"通知名称：%@",notification.name);
            AVCaptureDevice* device=[notification object];
            BOOL sessionHasDeviceWithMatchingMedia=NO;
            //定义输入设备的类型
            NSString* deviceMediaType=nil;
            if ([device hasMediaType:AVMediaTypeAudio])
            {
                deviceMediaType=AVMediaTypeAudio;
            }
            else if ([device hasMediaType:AVMediaTypeVideo])
            {
                deviceMediaType=AVMediaTypeVideo;
            }
            // 如果输入设备的类型不为nil
            if (deviceMediaType!=nil)
            {
                for(AVCaptureDeviceInput* input in [self.session inputs])
                {
                    if ([input.device hasMediaType:deviceMediaType])
                    {
                        sessionHasDeviceWithMatchingMedia=YES;
                        break;
                    }
                }
                if (!sessionHasDeviceWithMatchingMedia)
                {
                    NSError* error;
                    AVCaptureDeviceInput* input=[AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                    if ([self.session canAddInput:input])
                    {
                        //为AVCaptureSession添加输入设备
                        [self.session addInput:input];
                    }
                }
            }
            //调用委托方法通知委托对象，输入设备发生了改变
            if([self.delegate  respondsToSelector:@selector(recordManagerDeviceConfigurationChanged:)])
            {
                [self.delegate recordManagerDeviceConfigurationChanged:self];
            }
        };
        //定义输入设备断开链接时执行的代码块
        void (^deviceDisconnectedBlock)(NSNotification*)=
        ^(NSNotification* notification)
        {
            AVCaptureDevice* device=[notification object];
            if ([device hasMediaType:AVMediaTypeAudio])
            {
                [self.session removeInput:[weakSelf audioIput]];
                [weakSelf setAudioIput:nil];
            }
            else if ([device hasMediaType:AVMediaTypeVideo])
            {
                [self.session removeInput:[weakSelf videoInput]];
                [weakSelf setVideoInput:nil];
            }
            if ([self.delegate respondsToSelector:@selector(recordManagerDeviceConfigurationChanged:)])
            {
                [self.delegate recordManagerDeviceConfigurationChanged:self];
            }
        };
        //定义通知中心
        NSNotificationCenter* notificationCenter=[NSNotificationCenter defaultCenter];
        //使用通知中心监听输入设备连接的通知
        [self setDeviceConnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification object:nil queue:nil usingBlock:deviceConnectedBlock]];
        //使用通知中心监听输入设备断开的通知
        [self setDeviceDisconnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification object:nil queue:nil usingBlock:deviceDisconnectedBlock]];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        self.orientation=UIDeviceOrientationPortrait;
    }
    return self;
}


-(BOOL)setupSession
{
    BOOL success=NO;
    //如果该设备的后置摄像头有闪光灯
    if ([self.backFacingCamera hasFlash])
    {
        if ([self.backFacingCamera lockForConfiguration:nil])
        {
            if ([self.backFacingCamera isFlashModeSupported:AVCaptureFlashModeAuto])
            {
                //将后置摄像头的闪光灯设置为子自动模式
                [self.backFacingCamera setFlashMode:AVCaptureFlashModeAuto];
            }
            [self.backFacingCamera unlockForConfiguration];
        }
    }
    //如果该设备后置摄像头有电筒
    if ([self.backFacingCamera hasTorch])
    {
        if ([self.backFacingCamera lockForConfiguration:nil])
        {
            if ([self.backFacingCamera isTorchAvailable])
            {
                [self.backFacingCamera setTorchMode:AVCaptureTorchModeAuto];
            }
        }
    }
    //初始化输入设备
    AVCaptureDeviceInput* newVedioInput=[[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:nil];
    AVCaptureDeviceInput* newAudioInput=[[AVCaptureDeviceInput alloc] initWithDevice:[self audioDevice] error:nil];
    //设置静态照片输出端
    AVCaptureStillImageOutput* newStillImageOutput=[[AVCaptureStillImageOutput alloc] init];
    //设置输出照片的格式
    NSDictionary* outputSettings=[[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    [newStillImageOutput setOutputSettings:outputSettings];
    AVCaptureSession* newCaptureSession=[[AVCaptureSession alloc] init];
    //将输入输出设备添加到AVCaptureSession中
    if ([newCaptureSession canAddInput:newAudioInput])
    {
        [newCaptureSession addInput:newAudioInput];
    }
    if ([newCaptureSession canAddInput:newVedioInput])
    {
        [newCaptureSession addInput:newVedioInput];
    }
    if ([newCaptureSession canAddOutput:newStillImageOutput])
    {
        [newCaptureSession addOutput:newStillImageOutput];
    }
    self.stillImageOutput=newStillImageOutput;
    self.videoInput=newVedioInput;
    self.audioIput=newAudioInput;
    self.session=newCaptureSession;
    //设置视频的输出设备
    NSURL* outputFileURL=[self tempFileURL];
    Recorder* newRecorder=[[Recorder alloc] initWithSession:(AVCaptureSession*)self.session outputFileURL:outputFileURL];
    newRecorder.delegate=self;
    //如果不能录制视频，则发错误给代理
    if (newRecorder.recordersAudio&&!newRecorder.recordersVedio)
    {
        NSDictionary* errorDict=[[NSDictionary alloc] initWithObjectsAndKeys:@"不能录制视频",NSLocalizedDescriptionKey,@"不能录制视频，将只有音频文件",NSLocalizedFailureReasonErrorKey, nil];
        //初始化error
        NSError* noVedioError=[NSError  errorWithDomain:@"Record" code:0 userInfo:errorDict];
        if ([self.delegate respondsToSelector:@selector(recordManager:didFailWithError:)])
        {
            [self.delegate recordManager:self didFailWithError:noVedioError];
        }
        
    }
    self.recorder=newRecorder;
    success = YES;
    return success;
}

//开始录制
-(void)starRecording
{
    // 如果当前设备支持多任务
    if ([[UIDevice currentDevice] isMultitaskingSupported])
    {
        [self setBackgroundRecordID:(int)[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{}]];
    }
    [self removeFile:[[self recorder] outputFileURL]];
    //开始录制
    NSLog(@"%@",self.recorder);
    [self.recorder startRecordingWithOrientation:self.orientation];
}

//停止录制
-(void)stopRecording
{
    [self.recorder stopRecording];
}

//定义捕捉静态图片的方法
-(void)captureStillImage
{
    //获取拍照的AVCaptureConnection
    AVCaptureConnection* stillImageConnection=[RecordUtils connectionWithMediaType:AVMediaTypeVideo fromConnections:[self.stillImageOutput connections]];
    if ([stillImageConnection isVideoOrientationSupported])
    {
        [stillImageConnection setVideoOrientation:self.orientation];
    }
    //拍照并保存
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
    {
        ALAssetsLibraryWriteImageCompletionBlock completionBlock=
        ^(NSURL* assetURL,NSError* error)
        {
            if (error)
            {
                if ([self.delegate respondsToSelector:@selector(recordManager:didFailWithError:)])
                {
                    [self.delegate recordManager:self didFailWithError:error];
                }
            }
        };
        //如果图片缓存不为NULL
        if (imageDataSampleBuffer!=NULL)
        {
            NSData* imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            // 创建ASSetsLibrary,用于将照片写入相册
            ALAssetsLibrary* assetsLibrary=[[ALAssetsLibrary alloc] init];
            UIImage* image=[[UIImage alloc]initWithData:imageData];
            [assetsLibrary writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:completionBlock];
        }
        else
        {
            completionBlock(nil,error);
        }
        if ([self.delegate respondsToSelector:@selector(recordManagerStillImageCaptured:)])
        {
            [self.delegate recordManagerStillImageCaptured:self];
        }
        
    }];
}
//切换摄像头的方法
-(BOOL)toggleCamera
{
    BOOL success=NO;
    //只有当摄像头数量大于1的时候才能切换
    if (self.cameraCount>1)
    {
        NSError* error;
        AVCaptureDeviceInput* newVedioInput;
        AVCaptureDevicePosition position=[self.videoInput.device position];
        //如果当前正在使用后置摄像头
        if (position==AVCaptureDevicePositionBack)
        {
            newVedioInput=[[AVCaptureDeviceInput alloc] initWithDevice:self.frontFacingCamera error:&error];
            NSLog(@"//切换摄像头的方法");
        }
        //如果当前正在使用前置摄像头
        else if (position==AVCaptureDevicePositionFront)
        {
            newVedioInput=[[AVCaptureDeviceInput alloc] initWithDevice:self.backFacingCamera error:&error];
        }
        //直接返回失败
        else
        {
            return NO;
        }
       //如果视频设备不为nil
        if (newVedioInput!=nil)
        {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVedioInput])
            {
                [self.session addInput:newVedioInput];
                self.videoInput=newVedioInput;
            }
            else
            {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
            success=YES;
        }
        else if (error)
        {
            if ([self.delegate respondsToSelector:@selector(recordManager:didFailWithError:)])
            {
                [self.delegate recordManager:self didFailWithError:error];
            }
        }
    }
    
    return success;
}

// 获取摄像头的数量
-(NSInteger)cameraCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

//获取麦克风的数量
-(NSInteger)micCount
{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] count];
}

// 设置自动对焦的方法
-(void)autoFocusAtPoint:(CGPoint)point
{
    //获取视频输入设备
    AVCaptureDevice* device=[self.videoInput device];
    if ([device isFocusPointOfInterestSupported]&&[device isFocusModeSupported:AVCaptureFocusModeAutoFocus])
    {
        NSError* error;
        if ([device lockForConfiguration:&error])
        {
            [device setFocusPointOfInterest:point];
            //设置自动对焦
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(recordManager:didFailWithError:)])
            {
                [self.delegate recordManager:self didFailWithError:error];
            }
        }
    }
}

//设置连续对焦的方法
-(void)continuousFoucsAtPoint:(CGPoint)point
{
    //获取视频输入设备
    AVCaptureDevice* device=[self.videoInput device];
    if ([device isFocusPointOfInterestSupported]&&[device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
    {
        NSError* error;
        if ([device lockForConfiguration:&error])
        {
            [device setFocusPointOfInterest:point];
            //设置连续对焦
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [device unlockForConfiguration];
        }
        // 如果设置失败，则将错误返回给代理对象
        else
        {
            if ([self.delegate respondsToSelector:@selector(recordManager:didFailWithError:)])
            {
                [self.delegate recordManager:self didFailWithError:error];
            }
        }
    }
}

#pragma -mark 调用RecorderDelegate代理协议的方法
-(void)recorderRecordingDidBegin:(Recorder *)recorder
{
    //调用代理对象的RecordManagerRecordingBegan方法
    if ([self.delegate respondsToSelector:@selector(recordManagerRecordingBegan:)])
    {
        [self.delegate recordManagerRecordingBegan:self];
    }
}

-(void)recorder:(Recorder *)recorder recordingDidFinishToOutputFileURL:(NSURL *)outputFileURL error:(NSError *)error
{
    //如果正在录制音频，没有录制视频
    if ([self.recorder recordersAudio]&&![self.recorder recordersAudio])
    {
        //将outputFileURL文件复制到Document目录下
        [self CopyFileToDocument:outputFileURL];
        //如果当前设备支持多任务, 则停止后台任务
        if ([[UIDevice currentDevice] isMultitaskingSupported])
        {
            [[UIApplication  sharedApplication] endBackgroundTask:self.backgroundRecordID];
        }
        //通知代理代理对象，录制完成
        if ([self.delegate respondsToSelector:@selector(recordManagerRecordingFinished:)])
        {
            [self.delegate recordManagerRecordingFinished:self];
        }
    }
    else
    {
        //创建ALAssetsLibrary将视频添加到相册库中
        ALAssetsLibrary* library=[[ALAssetsLibrary alloc] init];
        [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error)
        {
            //如果有错误
            if (error)
            {
                //将错误发送给代理对象
                if([self.delegate respondsToSelector:@selector(recordManager:didFailWithError:)])
                {
                    [self.delegate recordManager:self didFailWithError:error];
                }
            }
            //如果当前设备支持多任务，则停止后台任务
            if ([[UIDevice currentDevice] isMultitaskingSupported])
            {
                [[UIApplication sharedApplication] endBackgroundTask:self.backgroundRecordID];
            }
            //通知代理对象，录制完成
            if ([self.delegate respondsToSelector:@selector(recordManagerRecordingFinished:)])
            {
                [self.delegate recordManagerRecordingFinished:self];
            }
        }];
    }
}

@end


@implementation RecordManager (internalUtilityMethods)
//跟踪设备方向的改变，保证视频和照片的方向与设备的方向一致
-(void)deviceOrientationDidChange
{
    UIDeviceOrientation deviceOrientation=[[UIDevice currentDevice] orientation];
    if (deviceOrientation==UIDeviceOrientationPortrait)
    {
        self.orientation=UIDeviceOrientationPortrait;
    }
    else if (deviceOrientation==UIDeviceOrientationPortraitUpsideDown)
    {
        self.orientation=UIDeviceOrientationPortraitUpsideDown;
    }
    else if (deviceOrientation==UIDeviceOrientationLandscapeLeft)
    {
        self.orientation=UIDeviceOrientationLandscapeLeft;
    }
    else if (deviceOrientation==UIDeviceOrientationLandscapeRight)
    {
        self.orientation=UIDeviceOrientationLandscapeRight;
    }
    
}
//定义一个方法，获取前置或者后置视频设备
-(AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position
{
    //获取所有的视频设备
    NSArray* devices=[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    //遍历所有的视频设备
    for(AVCaptureDevice* device in devices)
    {
        //如果该设备与被查找的位置相同，则返回该设备
        if (device.position==position)
        {
            return device;
        }
        
    }
    return  nil;
}

//定义获取前置摄像头的方法
-(AVCaptureDevice*)frontFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}
//定义获取后置摄像头的方法
-(AVCaptureDevice*)backFacingCamera
{
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}
//定义获取音频设备的方法
-(AVCaptureDevice*)audioDevice
{
    NSArray* audios=[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio];
    if (audios.count>0)
    {
        return [audios objectAtIndex:0];
    }
    return nil;
}
//定义获取临时文件URL的方法
-(NSURL*)tempFileURL
{
    return [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@%@",NSTemporaryDirectory(),@"output.mov"]];
}

//定义删除文件的方法
-(void)removeFile:(NSURL *)FileURL
{
    NSString* filePath=[FileURL path];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    //如果要删除的文件存在
    if ([fileManager fileExistsAtPath:filePath])
    {
        NSError* error;
        //删除文件，如果删除失败，则发送消息给大代理对象
        if ([fileManager removeItemAtPath:filePath error:&error])
        {
            if ([self.delegate respondsToSelector:@selector(recordManager:didFailWithError:)])
            {
                [self.delegate recordManager:self didFailWithError:error];
            }
        }
    }
}
//复制文件的方法
-(void)CopyFileToDocument:(NSURL *)fileURL
{
    //  获取HOME路径
    NSString* documentDirectory=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //创建日期格式期
    NSDateFormatter* dataFormatter=[[NSDateFormatter alloc] init];
    [dataFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
    //定义复制文件的目标文件名
    NSString* destinationPath=[documentDirectory stringByAppendingFormat:@"/output_%@.mov",[dataFormatter stringFromDate:[NSDate date]]];
    NSError* error;

    //复制文件，如果复制失败，则发送消息给代理对象
    if (![[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:[NSURL fileURLWithPath:destinationPath] error:&error])
    {
        if ([self.delegate respondsToSelector:@selector(recordManager:didFailWithError:)])
        {
            [self.delegate recordManager:self didFailWithError:error];
        }
    }
}
@end
