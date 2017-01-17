//
//  ViewController.h
//  CustomCamera
//
//  Created by comfouriertech on 16/8/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recorder.h"
#import "RecordManager.h"
@class Recorder;
@interface ViewController : UIViewController

@property (nonatomic,retain) RecordManager* recordManager;
@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *recordButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraToggleButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stillButton;

- (IBAction)toggleRecording:(id)sender;
- (IBAction)toggleCamera:(id)sender;
- (IBAction)captureStillImage:(id)sender;
@end

