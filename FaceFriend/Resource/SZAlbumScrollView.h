//
//  SZAlbumScrollView.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/11.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZAlbumScrollView : UIScrollView

-(instancetype)initWithFrame:(CGRect)frame contenSize:(CGSize)size;
-(instancetype)update:(CGRect)frame contenSize:(CGSize)size;
//-(void)addAlbumBtnWithTags:(NSMutableArray*)tags noRepeatTags:(NSMutableArray*)noRepeatTags photoURL:(NSMutableArray*)photoURL;
@end
