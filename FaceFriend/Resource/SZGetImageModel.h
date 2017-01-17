//
//  SZGetPhotoModel.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/19.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface SZGetImageModel : NSObject
@property (nonatomic,strong) NSMutableArray* images;
+(instancetype)defaultModel;
- (NSMutableArray*)reloadImagesFromLibrary;
@end
