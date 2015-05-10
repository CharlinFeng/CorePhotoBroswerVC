//
//  PPTLayout.m
//  CorePPTVC
//
//  Created by 冯成林 on 15/4/30.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoBroswerLayout.h"

@implementation PhotoBroswerLayout



+(instancetype)layout:(CGSize)size{
    
    PhotoBroswerLayout *layout = [[PhotoBroswerLayout alloc] init];
    
    //设置大小
    layout.itemSize = size;
    
    //设置滚动方向:水平
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //间距
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    
    return layout;
}



@end
