//
//  PBModel.m
//  CorePhotoBroswerVC
//
//  Created by 成林 on 15/5/4.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoModel.h"
#import "CoreArchive.h"



@implementation PhotoModel



/*
 *  检查数组合法性
 */
+(NSString *)check:(NSArray *)photoModels type:(PhotoBroswerVCType)type{
    
    if(photoModels==nil || photoModels.count==0) return NO;
    
    __block NSString *result =nil;
    
    [photoModels enumerateObjectsUsingBlock:^(PhotoModel *photoModel, NSUInteger idx, BOOL *stop) {
        
        if(photoModel.mid ==0){
            
            result = @"错误：请为每个相册模型对象传入唯一的mid标识，因为保存图片涉及缓存等需要唯一标识,且不能为0";
            
            *stop = YES;
        }
        
        if(PhotoBroswerVCTypeZoom == type){
            
            if(photoModel.sourceImageView == nil){
                result = @"错误：当PhotoBroswerVCTypeZoom == type时，请传入源imageView控件,即需要传photoModel.sourceImageView属性。";
                *stop = YES;
            }
        }
    }];
    
    return result;
}


/**
 *  读取
 *
 *  @return 是否已经保存到本地
 */
-(BOOL)read{
    
    return [CoreArchive boolForKey:[NSString stringWithFormat:@"%@",@(self.mid)]];
}

/*
 *  保存
 */
-(void)save;{
    [CoreArchive setBool:YES key:[NSString stringWithFormat:@"%@",@(self.mid)]];
}

-(CGRect)sourceFrame{
    return [_sourceImageView convertRect:_sourceImageView.bounds toView:_sourceImageView.window];
}


@end
