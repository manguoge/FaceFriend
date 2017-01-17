//
//  SZPhotoGraph.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/10.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recorder.h"
#import "RecordManager.h"
@class Recorder;
@interface SZPhotoGraphVC : UIViewController
@property (nonatomic,retain) RecordManager* recordManager;
@property (weak, nonatomic) UIView *videoPreviewView;

@property (weak, nonatomic) UIButton *recordButton;
@property (weak, nonatomic) UIButton *cameraToggleButton;
@property (weak, nonatomic) UIButton *stillButton;

@end
