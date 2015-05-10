//
//  PhotoImageView.m
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/5.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoImageView.h"
#import "UIView+PBExtend.h"
#import "PBConst.h"
#import "UIView+Extend.h"

@interface PhotoImageView ()

/** bounds */
@property (nonatomic,assign) CGRect screenBounds;

/** center*/
@property (nonatomic,assign) CGPoint screenCenter;

@end


@implementation PhotoImageView




-(void)setImage:(UIImage *)image{
    
    if(image == nil) return;
    
    [super setImage:image];
    
    //确定frame
    [self calFrame];
    
    if(_ImageSetBlock != nil) _ImageSetBlock(image);
}



/*
 *  确定frame
 */
-(void)calFrame{
    
    CGSize size = self.image.size;
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    CGRect superFrame = self.screenBounds;
    CGFloat superW =superFrame.size.width ;
    CGFloat superH =superFrame.size.height;
    
    CGFloat calW = superW;
    CGFloat calH = superW;
    
    if (w>=h) {//较宽
        
        if(w> superW){//比屏幕宽
            
            CGFloat scale = superW / w;
            
            //确定宽度
            calW = w * scale;
            calH = h * scale;
            
        }else if(w <= superW){//比屏幕窄，直接居中显示
            
            calW = w;
            calH = h;
        }
        
    }else if(w<h){//较高
        
        CGFloat scale1 = superH / h;
        CGFloat scale2 = superW / w;
        
        BOOL isFat = w * scale1 > superW;//比较胖
        
        CGFloat scale =isFat ? scale2 : scale1;
 
        if(h> superH){//比屏幕高
            
            //确定宽度
            calW = w * scale;
            calH = h * scale;

        }else if(h <= superH){//比屏幕窄，直接居中显示
            
            if(w>superW){
                                    
                //确定宽度
                calW = w * scale;
                calH = h * scale;
                    
                
            }else{
                calW = w;
                calH = h;
            }
            
        }
    }
    
    CGRect frame = [UIView frameWithW:calW h:calH center:self.screenCenter];
    
    self.frame = frame;
}










-(CGRect)screenBounds{
    
    if(CGRectEqualToRect(_screenBounds, CGRectZero)){
        
        _screenBounds = [UIScreen mainScreen].bounds;
    }
    
    return _screenBounds;
}

-(CGPoint)screenCenter{
    if(CGPointEqualToPoint(_screenCenter, CGPointZero)){
        CGSize size = self.screenBounds.size;
        _screenCenter = CGPointMake(size.width * .5f, size.height * .5f);
    }

    return _screenCenter;
}



@end
