//
//  CoreAleetViewManagerVC.m
//  CoreAleetView
//
//  Created by muxi on 15/3/3.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "CoreAleetViewManagerVC.h"

@interface CoreAleetViewManagerVC ()<UIAlertViewDelegate,UIActionSheetDelegate>

/**
 *  alertView
 *  注：不建议直接访问此属性
 */
@property (nonatomic,strong,readonly) UIAlertView *alertView;


/**
 *  actionSheet
 *  注：不建议直接访问此属性
 */
@property (nonatomic,strong,readonly) UIActionSheet *actionSheet;



/**
 *  block回调
 */
@property (nonatomic,copy) ClickedButtonBlock clickedButtonBlock;




@end

@implementation CoreAleetViewManagerVC


+(void)showWithAleetViewType:(CoreAleetViewType)aleetViewType inController:(UIViewController *)controller title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles clickedButtonBlock:(ClickedButtonBlock)clickedButtonBlock{
    
    //创建对象
    CoreAleetViewManagerVC *managerVC=[[CoreAleetViewManagerVC alloc] init];
    
    //加入子控制器，保住自己的命
    [controller addChildViewController:managerVC];
    
    //记录type
    managerVC.aleetViewType=aleetViewType;
    
    //根据不同的type创建视图
    [managerVC madeViewWithAleetViewType:aleetViewType title:title message:message cancelButtonTitle:cancelButtonTitle destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:otherButtonTitles];
    
    //记录block
    managerVC.clickedButtonBlock=clickedButtonBlock;
}



/**
 *  根据不同的类型创建视图:
 */
-(void)madeViewWithAleetViewType:(CoreAleetViewType)aleetViewType title:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles{
    
    if(CoreAleetViewTypeUIAlertView == aleetViewType){
        
        //创建alertView
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil, nil];
        
        //记录
        _alertView=alertView;
        
        //添加其他标题
        if(otherButtonTitles!=nil && otherButtonTitles.count!=0){
            for (NSString *otherButtonTitle in otherButtonTitles) {
                [_alertView addButtonWithTitle:otherButtonTitle];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //显示
            [alertView show];
        });
        
    }else if(CoreAleetViewTypeUIActionSheet == aleetViewType){
        
        //创建actionSheet
        UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil, nil];
        
        //记录
        _actionSheet=actionSheet;
        //修正取消按钮
        _actionSheet.cancelButtonIndex=1;
        //添加其他标题
        if(otherButtonTitles!=nil && otherButtonTitles.count!=0){
            for (NSString *otherButtonTitle in otherButtonTitles) {
                [_actionSheet addButtonWithTitle:otherButtonTitle];
            }
        }
        
        // 同时添加一个取消按钮
        [_actionSheet addButtonWithTitle:cancelButtonTitle];
        
        _actionSheet.cancelButtonIndex = _actionSheet.numberOfButtons-1;
        
        //显示
        dispatch_async(dispatch_get_main_queue(), ^{
            
        [actionSheet showInView:self.parentViewController.view];
            
        });
    }
}




-(void)dealloc{
    
}


/**
 *  代理方法区
 */

/**
 *  UIAlertView
 */
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    dispatch_async(dispatch_get_main_queue(), ^{
        if(_clickedButtonBlock!=nil) _clickedButtonBlock(buttonIndex);
        //释放自己
        [self removeFromParentViewController];
    });
}


/**
 *  UIActionSheet
 */
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //index修复
    //获取总共的index
    NSInteger count=actionSheet.numberOfButtons;
    
    if(buttonIndex!=0){
        
        if(buttonIndex>=count-1){
            buttonIndex=1;
        }else{
            buttonIndex=buttonIndex+1;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if(_clickedButtonBlock!=nil) _clickedButtonBlock(buttonIndex);
        //释放自己
        [self removeFromParentViewController];
    });
}


@end
