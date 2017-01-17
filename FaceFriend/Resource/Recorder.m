//
//  Recorder.m
//  CustomCamera
//
//  Created by comfouriertech on 16/8/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "Recorder.h"

@implementation Recorder
- (id) initWithSession:(AVCaptureSession *)aSession
         outputFileURL:(NSURL *)anOutputFileURL
{
    self = [super init];
    if (self != nil)
    {
        AVCaptureMovieFileOutput *aMovieFileOutput =
        [[AVCaptureMovieFileOutput alloc] init];
        // 如果该AVCaptureSession能添加aMovieFileOutput，执行添加
        if ([aSession canAddOutput:aMovieFileOutput])
        {
            [aSession addOutput:aMovieFileOutput];
        }
        self.movieFileOutput = aMovieFileOutput;
        self.session = aSession;
        self.outputFileURL = anOutputFileURL;
    }
    return self;
}
// 返回是否录制视频
-(BOOL)recordsVideo
{
    AVCaptureConnection *videoConnection = [RecordUtils connectionWithMediaType:AVMediaTypeVideo fromConnections:[[self movieFileOutput] connections]];
    return videoConnection.isActive;
}
// 返回是否录制音频
-(BOOL)recordsAudio
{
    AVCaptureConnection *audioConnection = [RecordUtils connectionWithMediaType:AVMediaTypeAudio fromConnections:[[self movieFileOutput] connections]];
    return audioConnection.isActive;
}
// 判断是否正在录制
-(BOOL)isRecording
{
    return self.movieFileOutput.isRecording;
}
// 根据指定录制方向开始录制
-(void)startRecordingWithOrientation:(AVCaptureVideoOrientation)videoOrientation
{
    AVCaptureConnection *videoConnection = [RecordUtils connectionWithMediaType:
AVMediaTypeVideo fromConnections:[[self movieFileOutput] connections]];
    if ([videoConnection isVideoOrientationSupported])
    {
        videoConnection.videoOrientation = videoOrientation;
    }
    
    [self.movieFileOutput startRecordingToOutputFileURL:
     self.outputFileURL recordingDelegate:self];
}
// 停止录制

-(void)stopRecording
{
    [self.movieFileOutput stopRecording];
}
// 实现AVCaptureFileOutputRecordingDelegate协议中的方法：开始录制时执行该方法
- (void) captureOutput:(AVCaptureFileOutput *)captureOutput
didStartRecordingToOutputFileAtURL:(NSURL *)fileURL
       fromConnections:(NSArray *)connections
{
    if ([self.delegate respondsToSelector:
         @selector(recorderRecordingDidBegin:)])
    {
        NSLog(@"AVCaptureFileOutputRecordingDelegate:开始录制时执行该方法");
        [self.delegate recorderRecordingDidBegin:self];
    }
}
// 实现AVCaptureFileOutputRecordingDelegate协议中的方法：录制完成时执行该方法
- (void) captureOutput:(AVCaptureFileOutput *)captureOutput
didFinishRecordingToOutputFileAtURL:(NSURL *)anOutputFileURL
       fromConnections:(NSArray *)connections error:(NSError *)error
{
    if ([self.delegate respondsToSelector:
         @selector(recorder:recordingDidFinishToOutputFileURL:error:)])
    {
        [self.delegate recorder:self
recordingDidFinishToOutputFileURL:anOutputFileURL error:error];
    }
}
@end
