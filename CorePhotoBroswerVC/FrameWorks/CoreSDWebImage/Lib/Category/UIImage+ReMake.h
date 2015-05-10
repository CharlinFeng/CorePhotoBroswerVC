//
//  UIImage+ReMake.h
//  CoreSDWebImage
//
//  Created by 成林 on 15/5/6.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ReMake)


-(UIImage *)remakeImageWithFullSize:(CGSize)fullSize zoom:(CGFloat)zoom;



/*
 *  生成一个默认的占位图片：bundle默认图片
 */
+(UIImage *)phImageWithSize:(CGSize)fullSize zoom:(CGFloat)zoom;





@end
