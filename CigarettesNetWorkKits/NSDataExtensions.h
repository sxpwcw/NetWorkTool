//
//  NSDataExtensions.h
//  CigarettesNetWorkKits
//
//  Created by Jack on 15/6/15.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (NSDataExtensions)
/**
 *  将数据转换为GB2312编码的中文字符串
 *
 *  @return 转换完成后的数据
 */
-(NSString *)ToGB2312String;
/**
 *  将数据转换为ASCII字符串
 *
 *  @return 转换完成后的数据
 */
-(NSString *)ToASCIIString;
/**
 *  将数据转换为UTF-8编码的字符串
 *
 *  @return 转换完成后的数据
 */
-(NSString *)ToUtf8String;

@end
