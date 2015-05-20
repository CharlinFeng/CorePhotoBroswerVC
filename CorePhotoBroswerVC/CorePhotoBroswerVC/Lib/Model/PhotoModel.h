//
//  PBModel.h
//  CorePhotoBroswerVC
//
//  Created by 成林 on 15/5/4.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PhotoBroswerType.h"

@interface PhotoModel : NSObject

/** mid，保存图片缓存唯一标识，必须传 */
@property (nonatomic,assign) NSUInteger mid;




/*
 *  网络图片
 */

/** 高清图地址 */
@property (nonatomic,copy) NSString *image_HD_U;



/*
 *  本地图片
 */
@property (nonatomic,strong) UIImage *image;









/** 标题 */
@property (nonatomic,copy) NSString *title;

/** 描述 */
@property (nonatomic,copy) NSString *desc;

/** 源frame */
@property (nonatomic,assign,readonly) CGRect sourceFrame;

/** 源imageView */
@property (nonatomic,weak) UIImageView *sourceImageView;

/** 是否从源frame放大呈现 */
@property (nonatomic,assign) BOOL isFromSourceFrame;


/*
 *  检查数组合法性
 */
+(NSString *)check:(NSArray *)photoModels type:(PhotoBroswerVCType)type;



/**
 *  读取
 *
 *  @return 是否已经保存到本地
 */
-(BOOL)read;



/*
 *  保存
 */
-(void)save;





@end
