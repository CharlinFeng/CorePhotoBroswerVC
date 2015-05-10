//
//  ViewController.m
//  CorePhotoBroswerVC
//
//  Created by 成林 on 15/5/4.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "ViewController.h"
#import "PhotoBroswerVC.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}


- (IBAction)showAction:(id)sender {
    
    //本地图片展示
    [self localImageShow];
    
    //展示网络图片
//    [self networkImageShow];
}

/*
 *  本地图片展示
 */
-(void)localImageShow{
    
    [PhotoBroswerVC show:self index:2 photoModelBlock:^NSArray *{
        
        NSArray *localImages = @[
                                 
                                 [UIImage imageNamed:@"15"],
                                 [UIImage imageNamed:@"14"],
                                 [UIImage imageNamed:@"13"],
                                 [UIImage imageNamed:@"12"],
                                 [UIImage imageNamed:@"11"]
                                 ];
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:localImages.count];
        for (NSUInteger i = 0; i< localImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            pbModel.image = localImages[i];
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
        
    }];
}


/*
 *  展示网络图片
 */
-(void)networkImageShow{
    
    [PhotoBroswerVC show:self index:2 photoModelBlock:^NSArray *{
        
        
        NSArray *networkImages=@[
                          @"http://www.fevte.com/data/attachment/forum/day_110425/110425102470ac33f571bc1c88.jpg",
                          @"http://www.netbian.com/d/file/20150505/5a760278eb985d8da2455e3334ad0c0f.jpg",
                          @"http://www.netbian.com/d/file/20141006/e9d6f04046d483843d353d7a301d36f8.jpg",
                          @"http://www.netbian.com/d/file/20130906/134dca4108f3f0ed10a4cc3f78848856.jpg",
                          @"http://www.netbian.com/d/file/20121111/a03b9adb18a982f6a49aa7bfa7b82371.jpg",
                          @"http://www.netbian.com/d/file/20130421/e0dabeee4e1e62fe114799bc7e4ccd66.jpg",
                          @"http://www.netbian.com/d/file/20121012/c890c1da17bb5b4291e9733fad8efb42.jpg",
                          @"http://www.netbian.com/d/file/20150318/c5c68492a4d6998229d1b6068c77951e.jpg0"
                          ];
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            pbModel.image_HD_U = networkImages[i];
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
        
        
    }];
}





@end
