//
//  Recorder.h
//  CustomCamera
//
//  Created by comfouriertech on 16/8/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "RecordUtils.h"
@protocol RecorderDelegate;
@interface Recorder : NSObject<AVCaptureFileOutputRecordingDelegate>
@property (nonatomic,assign) id<NSObject,RecorderDelegate> delegate;
@property (nonatomic,strong) NSURL* outputFileURL;

@property (nonatomic,readonly) BOOL recordersVedio;
@property (nonatomic,readonly) BOOL recordersAudio;
@property (nonatomic,readonly,getter=isRecording) BOOL Recording;
@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic,retain) AVCaptureMovieFileOutput *movieFileOutput;
/*
 @property (nonatomic,retain) AVCaptureSession *session;
 @property (nonatomic,retain) AVCaptureMovieFileOutput *movieFileOutput;
 @property (nonatomic,copy) NSURL *outputFileURL;
 @property (nonatomic,readonly) BOOL recordsVideo;
 @property (nonatomic,readonly) BOOL recordsAudio;
 @property (nonatomic,readonly,getter=isRecording) BOOL recording;
 @property (nonatomic,assign) id <NSObject,FKRecorderDelegate> delegate;
 */
-(Recorder*)initWithSession:(AVCaptureSession*)session outputFileURL:(NSURL*)outputFileURL;
-(void)startRecordingWithOrientation:(AVCaptureVideoOrientation)orientation;
-(void)stopRecording;
@end

@protocol RecorderDelegate
@required
-(void)recorderRecordingDidBegin:(Recorder *)recorder;
-(void)recorder:(Recorder *)recorder recordingDidFinishToOutputFileURL:
(NSURL *)outputFileURL error:(NSError *)error;
@end