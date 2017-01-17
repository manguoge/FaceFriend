//
//  UIView+Additions.m
//

#import "UIView+Additions.h"

@implementation UIView (Additions)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)removeAllGestureRecognizers {
//    while (self.gestureRecognizers.count) {
//        UIGestureRecognizer *gestureRecognizer = self.gestureRecognizers.lastObject;
//        [self removeGestureRecognizer:gestureRecognizer];
//    }
//}

#pragma mark- Rotation

- (void)removeSubviewsFrom_1_ToTag:(NSInteger) maxTag
{
    for (int i = 1; i <= maxTag; i++) {
        UIView *subView = [self viewWithTag:i];
        if (subView) {
            [subView removeFromSuperview];
        }
    }
}

@end

@implementation UIView (ShowPromt)

////显示指示器
//- (void)showActivityIndicatorWithMessage:(NSString *)messageStr inRect:(CGRect)rect
//{
//    UIView *panelView = [self viewWithTag:9001];
//    if (panelView == nil) {  //避免叠加
//        if (CGRectEqualToRect(rect, CGRectZero)) {
//            rect = (CGRect){0, 0, self.frame.size};
//        }
//        UIView *panelView = [[UIView alloc] initWithFrame:rect];
//        panelView.tag = 9001;
//        panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//        panelView.userInteractionEnabled = YES;     //将所有点击吸收,起到模态的作用
//        [self addSubview:panelView];
//        
//        UIView *wrapperView = [[UIView alloc] init];
//        wrapperView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        wrapperView.layer.cornerRadius = 6.0;
//        [panelView addSubview:wrapperView];
//        
//        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        [indicator startAnimating];
//        [wrapperView addSubview:indicator];
//        
//        if (messageStr && messageStr.length > 0)
//        {
//            UILabel *messageLabel = [[UILabel alloc] init];
//            messageLabel.backgroundColor = [UIColor clearColor];
//            messageLabel.textColor = [UIColor whiteColor];
//            messageLabel.font = [UIFont boldSystemFontOfSize:13];
//            messageLabel.textAlignment = NSTextAlignmentCenter;
//            messageLabel.text = messageStr;
//            CGSize sizeOfMessageLabel = CGSizeZero;
//            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
//                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:messageLabel.font, NSFontAttributeName, nil];
//                sizeOfMessageLabel = [messageStr boundingRectWithSize:CGSizeMake(300, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
//            }
//            else
//            {
//                sizeOfMessageLabel = [messageStr sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(300, 200)];
//            }
//            
//            CGFloat maxWidth = MAX(indicator.width, sizeOfMessageLabel.width);
//            CGFloat totalHeight = indicator.size.height+sizeOfMessageLabel.height+8;
//            CGSize sizeOfWrapperView = CGSizeMake(maxWidth+30, totalHeight+30);
//            wrapperView.frame = (CGRect){(rect.size.width-sizeOfWrapperView.width)/2.0, (rect.size.height-sizeOfWrapperView.height)/2.0,sizeOfWrapperView};
//            indicator.frame = (CGRect){(sizeOfWrapperView.width-indicator.width)/2.0, (sizeOfWrapperView.height-totalHeight)/2.0,indicator.size};
//            messageLabel.frame = (CGRect){(sizeOfWrapperView.width-sizeOfMessageLabel.width)/2.0, totalHeight-sizeOfMessageLabel.height+indicator.top,sizeOfMessageLabel};
//            [wrapperView addSubview:messageLabel];
//        }
//        else
//        {
//            CGSize sizeOfWrapperView = CGSizeMake(indicator.size.width+30, indicator.size.height+30);
//            wrapperView.frame = (CGRect){(rect.size.width-sizeOfWrapperView.width)/2.0, (rect.size.height-sizeOfWrapperView.height)/2.0,sizeOfWrapperView};
//            indicator.frame = (CGRect){(sizeOfWrapperView.width-indicator.width)/2.0, (sizeOfWrapperView.height-indicator.height)/2.0,indicator.size};
//        }
//    }
//}

//隐藏指示器
- (void)hideActivityIndicator
{
    UIView *panelView = [self viewWithTag:9001];
    if (panelView) {
        [UIView animateWithDuration:0.3 animations:^{
            panelView.alpha = 0.0;
        } completion:^(BOOL finiseh){
            [panelView removeFromSuperview];
        }];
    }
}


//显示数字标记
- (void)showBadgeValue:(NSInteger)value bgColor:(UIColor *)bgColr textColor:(UIColor *)textColor inRect:(CGRect)rect
{
    //当前APP并不显示小于等于0的数据
    if (value <= 0) {
        [self hideBadgeValue];
        return;
    }
    if (bgColr == nil) {
        bgColr = [UIColor redColor];
    }
    if (textColor == nil) {
        textColor = [UIColor whiteColor];
    }
    
    UILabel *label = (UILabel *)[self viewWithTag:9003];
    if (label == nil) {
        label = [[UILabel alloc] initWithFrame:rect];
        label.tag = 9003;
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = label.height/2.0;
        [self addSubview:label];
    }
    label.backgroundColor = bgColr;
    label.textColor = textColor;
    label.text = [NSString stringWithFormat:@"%ld",(long)value];
    [self bringSubviewToFront:label];
}

//隐藏数字标记
- (void)hideBadgeValue
{
    UIView *badgeValueView = [self viewWithTag:9003];
    if (badgeValueView) {
        [badgeValueView removeFromSuperview];
    }
}

@end



@implementation UIButton (UIButtonExt)

- (void)centerImageAndTitle:(float)spacing
{
    // get the size of the elements here for readability
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(
                                            - (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(
                                            0.0, - imageSize.width, - (totalHeight - titleSize.height), 0.0);
}

- (void)centerImageAndTitle
{
    const int DEFAULT_SPACING = 0.0;
    [self centerImageAndTitle:DEFAULT_SPACING];
}

//设置产品颜色
- (void)setBackgroundColorForProduct:(UIColor *)color isWithCheckImage:(BOOL)withImage
{
    self.layer.cornerRadius = self.height/2.0;
    self.backgroundColor = color;
    UIImage *image;
    if ([color isEqual:[UIColor whiteColor]]) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        image = [UIImage imageNamed:@"selected_gray"];
    }
    else{
        self.layer.borderWidth = 0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        image = [UIImage imageNamed:@"selected_white"];
    }
    
    if (withImage == YES) {
        [self setImage:image forState:UIControlStateNormal];
    }
}

+ (UIButton *)navBarButtonWithTitle:(NSString *)theTitle
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 42, 26);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:theTitle forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithName:@"box_line@2x"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithName:@"box_line_up@2x"] forState:UIControlStateHighlighted];

    return button;
}

+ (UIButton *)navBarButtonWithImage:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 42, 30);
    [button setImage:image forState:UIControlStateNormal];
    
    return button;
}

@end


@implementation UIImage (Extend)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]; //该方法加载的图片，在使用过后会立即释放
    return image;
}

-(UIImage*)circledwithParam:(CGFloat)inset borderWidth:(CGFloat)width borderColor:(UIColor *)color needChange:(BOOL)needChange
{
    CGFloat temp = self.size.width > self.size.height ? self.size.width : self.size.height;  //强制转为正方形
    CGSize size = CGSizeMake(temp, temp);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGRect rect;
    if (needChange == YES) {
        //temp = self.size.width > self.size.height ? self.size.height : self.size.width; //长方形转圆形会变形
        rect = CGRectMake(inset, inset+0.5, temp - inset * 2.0f, temp - inset * 2.0f);
    }
    else{
        rect = CGRectMake(inset, inset+0.5, self.size.width - inset * 2.0f, self.size.height - inset * 2.0f);
    }
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

-(UIImage *)scaleToSize:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scaleSize,self.size.height*scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

- (UIImage *)getSquareImageWithScale:(float)scaleSize
{
    UIImage *image = [self scaleToSize:scaleSize];
    CGFloat min = MIN(image.size.width, image.size.height);
    image = [image getSubImage:CGRectMake((image.size.width-min)/2.0, (image.size.height-min)/2.0, min, min)];
    return image;
}

- (NSData *)toData
{
    NSData *data = UIImageJPEGRepresentation(self, 1);
    if (data == nil) {
        
        data = UIImagePNGRepresentation(self);
        
    }
    return data;
}


@end


@implementation UIImageView (Extend)

//显示指示器
- (void)showIndicatorView:(UIActivityIndicatorViewStyle)style  color:(UIColor *)color
{
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[self  viewWithTag:9005];
    if (indicatorView == nil) {
        indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        indicatorView.tag = 9005;
        indicatorView.color = color;
        indicatorView.hidesWhenStopped = YES;
        indicatorView.frame = (CGRect){(self.width-indicatorView.width)/2.0, (self.height-indicatorView.height)/2.0, indicatorView.size};
        [self addSubview:indicatorView];
    }
    [indicatorView startAnimating];
}

//隐藏指示器
- (void)hideIndicatorView
{
    UIActivityIndicatorView *indicatorView = (UIActivityIndicatorView *)[self  viewWithTag:9005];
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
}

@end


@implementation NSDate (Extend)

- (NSDateComponents *)dateIntervalSinceDate:(NSDate *)earlierDate
{
    if (earlierDate == nil) {
        return nil;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    //将每个日期的时间都设置为00:00:00，去除时间对天数的影响
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:earlierDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    NSDate *date1 = [formatter dateFromString:dateStr];
    dateStr = [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    NSDate *date2 = [formatter dateFromString:dateStr];
    return [calendar components:unitFlags fromDate:date1 toDate:date2 options:NSCalendarWrapComponents];
}

- (NSDateComponents *)birthdayIntervalSinceDate:(NSDate *)birthday
{
    if (birthday == nil) {
        return nil;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ;
    //将每个日期的时间都设置为00:00:00，去除时间对天数的影响
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    //今年生日
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    NSInteger currentYear = [comps year];
    NSDate *currentBirthday = [self birthdayOfYear:currentYear birthDay:birthday];
    //今天日期的简化版
    NSString *dateStr = [NSDateFormatter localizedStringFromDate:self dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
    NSDate *currentDate = [formatter dateFromString:dateStr];
    
    if ([currentBirthday timeIntervalSinceDate:currentDate] < 0) { //生日已过
        NSDate *nextBirthday = [self birthdayOfYear:currentYear+1 birthDay:birthday]; //下一年生日
        return [calendar components:unitFlags fromDate:currentDate toDate:nextBirthday options:NSCalendarWrapComponents];
    }
    return [calendar components:unitFlags fromDate:currentDate toDate:currentBirthday options:NSCalendarWrapComponents];
}

- (NSDate *)birthdayOfYear:(NSInteger)year birthDay:(NSDate *)birthday
{
    if (birthday == nil) {
        return nil;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay ;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:birthday];
    NSString *dateStr;
    if ([comps month] == 2 && [comps day] == 29) {
        if ((year % 4  == 0 && year % 100 != 0 ) || year % 400 == 0) {   //闰年
            dateStr = [NSString stringWithFormat:@"%ld-%d-%d",(long)year,2,29];
        }
        else{
            dateStr = [NSString stringWithFormat:@"%ld-%d-%d",(long)year,2,28];
        }
    }
    else{
        dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)[comps month],(long)[comps day]];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter dateFromString:dateStr];
}

//获得某年某月的天数
+ (NSInteger)daysOfYear:(NSInteger)year month:(NSInteger)month
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *dateString = [NSString stringWithFormat:@"%ld/%ld/%d",(long)year,(long)month,1];
    NSDate *date = [formatter dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                           inUnit:NSMonthCalendarUnit
                          forDate:date];
    
    return (NSInteger)days.length;
}

@end


@implementation NSString (DataCalculation)
/*
+ (NSString *)temperatureString:(NSString *)temperatureSourceValue withUnit:(BOOL)needUnit
{
    CGFloat temperatureValue = [temperatureSourceValue floatValue]/1000.0;
    if ([USER_DEFAULT integerForKey:UNIT_EAR_THERMOMETER] == 0) {   //单位为摄氏度
        if (needUnit == YES) {
            return temperatureValue<0 ? @"ºC" : [NSString stringWithFormat:@"%0.1fºC",temperatureValue];
        }
        else{
            return [NSString stringWithFormat:@"%0.1f",temperatureValue];
        }
    }
    else if ([USER_DEFAULT integerForKey:UNIT_EAR_THERMOMETER] == 1) { //华氏摄氏度
        if (needUnit == YES) {
            return temperatureValue<0 ? @"ºF" : [NSString stringWithFormat:@"%0.1fºF",temperatureValue*1.8+32];
        }
        else{
            return [NSString stringWithFormat:@"%0.1f",temperatureValue*1.8+32];
        }
    }
    else{
        if (needUnit == YES) {
            return temperatureValue<0 ? @"ºR" : [NSString stringWithFormat:@"%0.1fºR",(temperatureValue+273.15)*1.8];
        }
        else{
            return [NSString stringWithFormat:@"%0.1f",(temperatureValue+273.15)*1.8];
        }
    }
    return nil;
}

- (long)temperatureSourceValue
{
    long sourceValue = 0;
    if ([USER_DEFAULT integerForKey:UNIT_EAR_THERMOMETER] == 0) {   //单位为摄氏度
        sourceValue = [self floatValue]*1000;
    }
    else if ([USER_DEFAULT integerForKey:UNIT_EAR_THERMOMETER] == 1) { //华氏摄氏度
        sourceValue = ([self floatValue]-32)/1.8*1000;
    }
    else{
        sourceValue = ([self floatValue]/1.8-273.15)*1000;
    }
    return sourceValue;
}
 


+ (NSString *)weightString:(NSString *)weightSourceValue withUnit:(BOOL)needUnit
{
    CGFloat weightValue = [weightSourceValue floatValue]/1000.0;
    if ([USER_DEFAULT integerForKey:UNIT_WEIGHT_MACHINE] == 0) {   //kg
        if (needUnit == YES) {
            return weightValue<0 ? @"kg" : [NSString stringWithFormat:@"%0.3fkg",weightValue*0x100000/0x100000*5/1000];
        }
        else{
            return [NSString stringWithFormat:@"%0.3f",weightValue*0x100000/0x100000*5/1000];
        }
    }
    else if ([USER_DEFAULT integerForKey:UNIT_WEIGHT_MACHINE] == 1) { //lb
        if (needUnit == YES) {
            return weightValue<0 ? @"lb" : [NSString stringWithFormat:@"%0.2flb",weightValue*0x11a305/0x100000/100];
        }
        else{
            return [NSString stringWithFormat:@"%0.2f",weightValue*0x11a305/0x100000/100];
        }
    }
    else{
        if (needUnit == YES) {   //oz
            return weightValue<0 ? @"oz" : [NSString stringWithFormat:@"%0.1foz",weightValue*0x1c381b/0x100000/10];
        }
        else{
            return [NSString stringWithFormat:@"%0.1f",weightValue*0x1c381b/0x100000/10];
        }
    }
    return nil;
}

- (long)weightSourceValue
{
    long sourceValue = 0;
    if ([USER_DEFAULT integerForKey:UNIT_WEIGHT_MACHINE] == 0) {   //kg
        sourceValue = [self floatValue]*1000/5*0x100000/0x100000*1000; //放大1000倍，再转换回小数时就不会有差异
    }
    else if ([USER_DEFAULT integerForKey:UNIT_WEIGHT_MACHINE] == 1) { //lb
        sourceValue = [self floatValue]*100*0x100000/0x11a305*1000;
    }
    else{
        sourceValue = [self floatValue]*10*0x100000/0x1c381b*1000;
    }
    return sourceValue;
}

+ (NSString *)heightString:(NSString *)heightSourceValue withUnit:(BOOL)needUnit
{
    CGFloat heightValue = [heightSourceValue floatValue]/1000.0;
    if ([USER_DEFAULT integerForKey:UNIT_RULER] == 0) {   //单位为cm
        if (needUnit == YES) {
            return heightValue<0 ? @"cm" : [NSString stringWithFormat:@"%0.2fcm",heightValue];
        }
        else{
            return [NSString stringWithFormat:@"%0.2f",heightValue];
        }
    }
    else { //英尺
        if (needUnit == YES) {
            return heightValue<0 ? @"ft" : [NSString stringWithFormat:@"%0.2fft",heightValue/30.48];
        }
        else{
            return [NSString stringWithFormat:@"%0.2f",heightValue/30.48];
        }
    }

    
    return nil;
}

- (long)heightSourceValue
{
    long sourceValue = 0;
    if ([USER_DEFAULT integerForKey:UNIT_RULER] == 0) {   //单位为cm
        sourceValue = [self floatValue]*1000;
    }
    else { //英尺
        sourceValue = [self floatValue]*30.48*1000;
    }
    return sourceValue;
}
 */
+ (NSString *)bmiString:(NSString *)bmi
{
    return [NSString stringWithFormat:@"%0.2f",[bmi floatValue]/1000.0];
}

- (NSString *)fullPath
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentPath stringByAppendingPathComponent:self];
}

@end



@implementation NSData (DataToHexString)

- (NSString *) dataToHexString
{
    NSUInteger          len = [self length];
    char *              chars = (char *)[self bytes];
    NSMutableString *   hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    
    return hexString;
}
@end


