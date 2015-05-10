//
//  UIView+Extend.m
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/6.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "UIView+PBExtend.h"

@implementation UIView (PBExtend)

/*
 *  计算frame
 */
+(CGRect)frameWithW:(CGFloat)w h:(CGFloat)h center:(CGPoint)center{
    
    CGFloat x = center.x - w *.5f;
    CGFloat y = center.y - h * .5f;
    CGRect frame = (CGRect){CGPointMake(x, y),CGSizeMake(w, h)};
    
    return frame;
}


@end
