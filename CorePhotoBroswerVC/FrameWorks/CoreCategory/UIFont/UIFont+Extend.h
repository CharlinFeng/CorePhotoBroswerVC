//
//  UIFont+Extend.h
//  Wifi
//
//  Created by muxi on 14/12/1.
//  Copyright (c) 2014年 muxi. All rights reserved.
//  字体扩展
//
//  注：本类的主要目的是为了引入常用的web字体
//
//
//
#import <UIKit/UIKit.h>

@interface UIFont (Extend)

/**
 *  打印并显示所有字体
 */
+(void)showAllFonts;


/**
 *  宋体(字体缺失)
 */
+(UIFont *)songTypefaceFontOfSize:(CGFloat)size;





/**
 *  微软雅黑：正常字体
 */
+(UIFont *)microsoftYaHeiFontOfSize:(CGFloat)size;


/**
 *  微软雅黑：加粗字体(字体缺失)
 */
+(UIFont *)boldMicrosoftYaHeiFontOfSize:(CGFloat)size;


/**
 *  DroidSansFallback
 */
+(UIFont *)customFontNamedDroidSansFallbackWithFontOfSize:(CGFloat)size;

@end
