//
//  UIView+Additions.h
//

#import <UIKit/UIKit.h>



@interface UIView (Additions)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */

@property (nonatomic) CGSize size;

- (void)removeAllSubviews;
//- (void)removeAllGestureRecognizers;
- (void)removeSubviewsFrom_1_ToTag:(NSInteger) maxTag;  //rotation

@end

@interface UIView (ShowPromt)

/**
 * @brief 显示模态指示器(风火轮)+文本;在模态框居中显示
 *
 * @param message 显示的文本内容，不显示文本时可传入nil
 *
 * @param rect 模态框的位置和大小；若传入CGRectZero则用父视图的frame的大小来布局
 *
 */
//- (void)showActivityIndicatorWithMessage:(NSString *)message inRect:(CGRect)rect;

//隐藏指示器
- (void)hideActivityIndicator;

/**
 * @brief 在视图右上角显示数字标记，默认的位置不够好，可再行调整
 *
 * @param value 显示的数字
 *
 * @param bgColr 背景颜色，默认为红色
 *
 * @param textColor 数字颜色，默认为白色
 *
 * @param rect 数据标识的位置和大小
 *
 */
- (void)showBadgeValue:(NSInteger)value bgColor:(UIColor *)bgColr textColor:(UIColor *)textColor inRect:(CGRect)rect;

//隐藏数字标记
- (void)hideBadgeValue;

@end



@interface UIButton (UIButtonExt)

//按指定间隔(图片与文本的垂直距离)垂直居中button的图片和文本
- (void)centerImageAndTitle:(float)space;

//按默认间隔(0)垂直居中button的图片和文本
- (void)centerImageAndTitle;

//设置产品选择颜色
- (void)setBackgroundColorForProduct:(UIColor *)color isWithCheckImage:(BOOL)withImage;

+ (UIButton *)navBarButtonWithTitle:(NSString *)theTitle;

+ (UIButton *)navBarButtonWithImage:(UIImage *)image;

@end


@interface UIImage (Extend)

//生成纯色的图片
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//通过路劲获取图片，节省内存
+ (UIImage *)imageWithName:(NSString *)name;

/**
 * @brief 将图片修改为圆形
 *
 * @param inset 图片变为圆形之后，半径减少的值。例如原图100像素，inset=10，则最终圆形图半径为40，整体大小不变相当于多了透明边
 *
 * @param width 在图片外围增加的边框的宽度，所画边框锯齿明显
 *
 * @param color 在图片外围增加的边框的颜色
 *
 * @param needChange 是否需要将原图强制转为正方形
 *
 */
-(UIImage*)circledwithParam:(CGFloat)inset borderWidth:(CGFloat)width borderColor:(UIColor *)color needChange:(BOOL)needChange;

//压缩图片;scaleSize:压缩比例
-(UIImage *)scaleToSize:(float)scaleSize;

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect;

//按照比例获取正方形图形
- (UIImage *)getSquareImageWithScale:(float)scaleSize;

//将图片转为jpg格式，若不支持jpg则转为png格式
- (NSData *)toData;

@end


@interface UIImageView (Extend)

//显示指示器
- (void)showIndicatorView:(UIActivityIndicatorViewStyle)style  color:(UIColor *)color;

//隐藏指示器
- (void)hideIndicatorView;

@end


#define DATE_INTERVAL struct TimeInterval

DATE_INTERVAL
{
    int year;
    int month;
    int day;
};

@interface NSDate (Extend)

//和较早的一个日期之间的时间差，以年月日的方式返回
- (NSDateComponents *)dateIntervalSinceDate:(NSDate *)earlierDate;

- (NSDateComponents *)birthdayIntervalSinceDate:(NSDate *)birthday;

//获得某年某月的天数
+ (NSInteger)daysOfYear:(NSInteger)year month:(NSInteger)month;

@end

@interface NSString (DataCalculation)

//根据单位的不同返回对应的温度显示；temperature<0且needUnit为YES，仅返回单位
+ (NSString *)temperatureString:(NSString *)temperatureSourceValue withUnit:(BOOL)needUnit;

//将文本转换为数据
- (long)temperatureSourceValue;

//根据单位的不同返回对应的体重显示；weight<0且needUnit为YES，仅返回单位
+ (NSString *)weightString:(NSString *)weightSourceValue withUnit:(BOOL)needUnit;

//将文本转换为数据
- (long)weightSourceValue;

//根据单位的不同返回对应的身高显示；height<0且needUnit为YES，仅返回单位
+ (NSString *)heightString:(NSString *)heightSourceValue withUnit:(BOOL)needUnit;

//将文本转换为数据
- (long)heightSourceValue;

//返回需要显示的BMI
+ (NSString *)bmiString:(NSString *)bmi;



//返回在本地的全部路径
- (NSString *)fullPath;

@end

@interface NSData (DataToHexString)

//转成字符串
- (NSString *) dataToHexString;

@end

