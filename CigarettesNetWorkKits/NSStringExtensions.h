//
//  NSStringExtensions.h
//  CigarettesNetWorkKits
//
//  Created by Jack on 15/6/15.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface  NSString (NSStringExtensions)
/**
 *  将字符串转换为数据字节码
 *
 *  @return 转换完成后的数据
 */
-(NSData *)ToData;
/**
 *  将字符串转换为Base64编码
 *
 *  @return 转换完成后的数据
 */
-(NSString *)ToBase64;
/**
 *  把指定字符串删除最后一位
 *
 *  @return 转换完成后的数据
 */
-(NSString *)CutLastString;
/**
 *  判断最后一位字符串是否为指定的字符串，如果是则删除最后一位
 *
 *  @param opt 指定检查的最后一位字符串
 *
 *  @return 转换完成后的数据
 */
-(NSString *)CutLastStringWithString:(NSString *)opt;
/**
 *  将字符串内的空格删除
 *
 *  @return 转换完成后的数据
 */
-(NSString *)Trim;
/**
 *  将字符串转换为MD5
 *
 *  @return NSString
 */
-(NSString *)ToMd5;
/**
 *
 *将文字转换为Url编码
 *
 */
-(NSString *)EncodeUrlString;

-(UIColor *)colorHexStringWithalpha:(float)_alpha;
@end
