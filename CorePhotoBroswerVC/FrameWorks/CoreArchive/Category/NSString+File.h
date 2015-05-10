//
//  NSString+File.h
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSString (File)


/*
 *  document根文件夹
 */
+(NSString *)documentFolder;


/*
 *  caches根文件夹
 */
+(NSString *)cachesFolder;




/**
 *  生成子文件夹
 *
 *  如果子文件夹不存在，则直接创建；如果已经存在，则直接返回
 *
 *  @param subFolder 子文件夹名
 *
 *  @return 文件夹路径
 */
-(NSString *)createSubFolder:(NSString *)subFolder;


@end
