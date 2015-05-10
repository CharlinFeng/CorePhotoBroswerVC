//
//  CALayer+Anim.m
//  Carpenter
//
//  Created by 冯成林 on 15/4/23.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CALayer+Anim.h"

@implementation CALayer (Anim)


-(CAAnimation *)anim_shake:(NSArray *)rotations duration:(NSTimeInterval)duration repeatCount:(NSUInteger)repeatCount{
    
    //创建关键帧动画
    CAKeyframeAnimation *kfa = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //指定值
    kfa.values = rotations;
    
    //时长
    kfa.duration = duration;
    
    //重复次数
    kfa.repeatCount=repeatCount;
    
    //完成删除
    kfa.removedOnCompletion = YES;
    
    //添加
    [self addAnimation:kfa forKey:@"rotation"];
    
    return kfa;
}



-(CAAnimation *)anim_revers:(AnimReverDirection)direction duration:(NSTimeInterval)duration isReverse:(BOOL)isReverse repeatCount:(NSUInteger)repeatCount timingFuncName:(NSString *)timingFuncName{
    
    NSString *key = @"reversAnim";
    
    if([self animationForKey:key]!=nil){
        [self removeAnimationForKey:key];
    }
    
    NSString *directionStr = nil;
    
    if(AnimReverDirectionX == direction)directionStr=@"x";
    if(AnimReverDirectionY == direction)directionStr=@"y";
    if(AnimReverDirectionZ == direction)directionStr=@"z";
    
    //创建普通动画
    CABasicAnimation *reversAnim = [CABasicAnimation animationWithKeyPath:[NSString stringWithFormat:@"transform.rotation.%@",directionStr]];
    
    //起点值
    reversAnim.fromValue=@(0);
    
    //终点值
    reversAnim.toValue = @(M_PI_2);
    
    //时长
    reversAnim.duration = duration;
    
    //自动反转
    reversAnim.autoreverses = isReverse;
    
    //完成删除
    reversAnim.removedOnCompletion = YES;
    
    //重复次数
    reversAnim.repeatCount = repeatCount;
    
    //添加
    [self addAnimation:reversAnim forKey:key];
    
    return reversAnim;
}



@end
