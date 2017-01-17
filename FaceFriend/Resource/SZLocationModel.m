//
//  SZLocationModel.m
//  FaceFriend
//
//  Created by comfouriertech on 16/9/30.
//  Copyright © 2016年 ronghua_li. All rights reserved.
//

#import "SZLocationModel.h"
@implementation SZLocationModel
-(instancetype)init
{
    self=[super init];
    if (self)
    {
        if ([CLLocationManager locationServicesEnabled])
        {
            CLLocationManager* locationManager=[[CLLocationManager alloc] init];
            if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
            {
                [locationManager requestWhenInUseAuthorization];
                [locationManager requestAlwaysAuthorization];
            }
            locationManager.delegate=self;
            locationManager.desiredAccuracy=kCLLocationAccuracyBest;
            locationManager.distanceFilter=1000;
            self.locationManager=locationManager;
        }
        //定位服务不可用
        else
        {
            UIAlertView *disableDocateAlert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Location", nil) message:NSLocalizedString(@"You donn't open the Location function! ", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
            [disableDocateAlert show];
        }
        
    }
    return self;
}
-(NSString*)getCurrentCity
{
    //开启定位服务
    [self.locationManager startUpdatingLocation];
    return self.currentCity;
}
#pragma mark -CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //[self.locationManager stopUpdatingLocation];
    CLLocation* location = locations.lastObject;
    [self reverseGeocoder:location];
}

#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation
{
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
    {
        if(error || placemarks.count == 0)
        {
            NSLog(@"error0 = %@",error);
        }
        else
        {
            
            CLPlacemark* placemark = placemarks.firstObject;
            self.currentCity=[[placemark addressDictionary] objectForKey:@"City"];
            //NSLog(@"city:%@",self.currentCity);
        }
    }];
}

@end
