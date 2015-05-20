//
//  PhotoImageView.h
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/5.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoImageView : UIImageView

/** 设置图片后的回调 */
@property (nonatomic,copy) void (^ImageSetBlock)(UIImage *image);


@property (nonatomic,assign) CGRect calF;

@end
