//
//  CoreSVP.m
//  新浪微博2014MJ版
//
//  Created by muxi on 14/10/22.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "CoreSVP.h"

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]


@implementation CoreSVP


/**
 *  展示提示框
 *
 *  @param type          类型
 *  @param msg           文字
 *  @param duration      时间（当type=CoreSVPTypeLoadingInterface时无效）
 *  @param allowEdit     否允许编辑
 *  @param beginBlock    提示开始时的回调
 *  @param completeBlock 提示结束时的回调
 */
+(void)showSVPWithType:(CoreSVPType)type Msg:(NSString *)msg duration:(CGFloat)duration allowEdit:(BOOL)allowEdit beginBlock:(void(^)())beginBlock completeBlock:(void(^)())completeBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //基本配置
        [self hudSetting];

        if(CoreSVPTypeBottomMsg == type){
            [SVProgressHUD setOffsetFromCenter:UIOffsetMake(0, [UIScreen mainScreen].applicationFrame.size.height * .5f-49.0f)];
        }
        
        //设置时间
        [SVProgressHUD setDuration:duration];

        
        //错误图片
        [SVProgressHUD setErrorImage:[UIImage imageNamed:@"CoreSVP.bundle/SVPError"]];
        
        //成功图片
        [SVProgressHUD setSuccessImage:[UIImage imageNamed:@"CoreSVP.bundle/SVPSuccess"]];
        
        SVProgressHUDMaskType maskType=allowEdit?SVProgressHUDMaskTypeNone:SVProgressHUDMaskTypeClear;
        [SVProgressHUD setDefaultMaskType:maskType];
        
        //开始回调
        if(beginBlock != nil) beginBlock();
        
        //结束回调
        [SVProgressHUD setCompleteBlock:completeBlock];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (type) {
                    
                case CoreSVPTypeCenterMsg:
                case CoreSVPTypeBottomMsg:
                    [SVProgressHUD showImage:nil status:msg];
                    break;
                    
                case CoreSVPTypeInfo:
                    [SVProgressHUD showInfoWithStatus:msg];
                    break;
                    
                case CoreSVPTypeLoadingInterface:
                    [SVProgressHUD showWithStatus:msg];
                    break;
                    
                case CoreSVPTypeError:
                    [SVProgressHUD showErrorWithStatus:msg];
                    break;
                    
                case CoreSVPTypeSuccess:
                    [SVProgressHUD showSuccessWithStatus:msg];
                    break;
                    
                default:
                    break;
            }
        });
    });
}


/*
 *  进度
 */
+(void)showProgess:(CGFloat)progress Msg:(NSString *)msg maskType:(SVProgressHUDMaskType)maskType{
    
    if (progress<=0) progress = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //基本配置
        [self hudSetting];
        
        [SVProgressHUD showProgress:progress status:msg maskType:maskType];
        
        if(progress>=1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self dismiss];
            });
        }
    });
}


/*
 *  基本配置
 */
+(void)hudSetting{
    
    //设置背景色
    [SVProgressHUD setBackgroundColor:rgba(0, 0, 0, .68f)];
    
    //文字颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    //字体大小
    [SVProgressHUD setFont:[UIFont systemFontOfSize:18.0f]];
}


/**
 *  隐藏提示框
 */
+(void)dismiss{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
