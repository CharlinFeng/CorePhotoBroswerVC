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
+(BOOL)check:(NSArray *)photoModels{
    
    if(photoModels==nil || photoModels.count==0) return NO;
    
    __block BOOL isOK =YES;
    
    [photoModels enumerateObjectsUsingBlock:^(PhotoModel *photoModel, NSUInteger idx, BOOL *stop) {
        
        if(photoModel.mid ==0){
            
            isOK = NO;
            
            *stop = YES;
        }
        
    }];
    
    return isOK;
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


@end
