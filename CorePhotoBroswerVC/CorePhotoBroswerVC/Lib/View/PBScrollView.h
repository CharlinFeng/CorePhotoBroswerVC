//
//  PBScrollView.h
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/8.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBScrollView : UIScrollView

@property (nonatomic,assign) NSUInteger index;


/** 照片数组 */
@property (nonatomic,strong) NSArray *photoModels;



@end
