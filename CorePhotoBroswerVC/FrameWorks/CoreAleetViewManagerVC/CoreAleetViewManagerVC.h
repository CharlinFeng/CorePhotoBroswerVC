//
//  CoreAleetViewManagerVC.h
//  CoreAleetView
//
//  Created by muxi on 15/3/3.
//  Copyright (c) 2015年 muxi. All rights reserved.
//  核心提醒视图管理控制器：我们的目标
//  只管理以下视图:
//  UIAlertView
//  UIActionSheet

#import <UIKit/UIKit.h>

typedef void(^ClickedButtonBlock)(NSInteger index);

/**
 *  可定义的样式
 */
typedef enum {
    
    //UIAlertView
    CoreAleetViewTypeUIAlertView=0,

    //UIActionSheet
    CoreAleetViewTypeUIActionSheet,
    
}CoreAleetViewType;



@interface CoreAleetViewManagerVC : UIViewController




/**
 *  视图样式
 */
@property (nonatomic,assign) CoreAleetViewType aleetViewType;




+(void)showWithAleetViewType:(CoreAleetViewType)aleetViewType inController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles clickedButtonBlock:(ClickedButtonBlock)clickedButtonBlock;




@end
