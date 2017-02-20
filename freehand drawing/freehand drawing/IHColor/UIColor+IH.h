//
//  UIColor+IH.h
//  IHKit
//
//  Created by lm-zz on 05/01/2017.
//  Copyright © 2017 lm-zz. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef UIColorHex
    #define UIColorHex(_hex_)   [UIColor ih_colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]
#endif

#ifndef UIColorRGB
    #define UIColorRGB(_rgbValue_) [UIColor ih_colorWithRGB:(_rgbValue_)]
#endif

#ifndef UIColorRGBA
    #define UIColorRGBA(_rgbaValue_) [UIColor ih_colorWithRGBA:(_rgbaValue_)]
#endif

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (IH)

@property (nonatomic, readonly) CGFloat red;                            //color red value
@property (nonatomic, readonly) CGFloat green;                          //color green value
@property (nonatomic, readonly) CGFloat blue;                           //color blue value
@property (nonatomic, readonly) CGFloat alpha;
@property (nullable, nonatomic, readonly) NSString *hexString;
@property (nullable, nonatomic, readonly) NSString *hexStringWithAlpha;


/**
 通过rgb值获取UIColor

 @param rgbValue rgb

 @return UIColor
 */
+ (UIColor *)ih_colorWithRGB:(uint32_t)rgbValue;

/**
 通过rgba值获取UIColor

 @param rgbaValue rgba

 @return UIColor
 */
+ (UIColor *)ih_colorWithRGBA:(uint32_t)rgbaValue;

/**
 通过rgb值 和 alpha值 获取UIColor
 
 @param rgbValue rgb
 @param alpha    alpha

 @return UIColor
 */
+ (UIColor *)ih_colorWithRGB:(uint32_t)rgbValue alpha:(CGFloat)alpha;

/**
 通过hex值获取UIColor

 @param hexStr hex

 @return UIColor
 */
+ (nullable UIColor *)ih_colorWithHexString:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END
