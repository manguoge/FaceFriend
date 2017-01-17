//
//  SZLocationModel.h
//  FaceFriend
//
//  Created by comfouriertech on 16/9/30.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SZLocationModel : NSObject<CLLocationManagerDelegate>
@property (nonatomic,strong) CLLocationManager* locationManager;
@property (nonatomic,strong) NSString* currentCity;
-(instancetype)init;
-(NSString*)getCurrentCity;
@end
