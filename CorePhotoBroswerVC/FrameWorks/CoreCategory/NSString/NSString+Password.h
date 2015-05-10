//
//  NSString+Password.h
//  03.数据加密
//
//  Created by 刘凡 on 13-12-10.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Password)





/**
 *  32位MD5加密
 */
@property (nonatomic,copy,readonly) NSString *md5;





/**
 *  SHA1加密
 */
@property (nonatomic,copy,readonly) NSString *sha1;





@end
