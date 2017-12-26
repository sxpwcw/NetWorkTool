//
//  NSDataExtensions.m
//  CigarettesNetWorkKits
//
//  Created by Jack on 15/6/15.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import "NSDataExtensions.h"

@implementation NSData (NSDataExtensions)

-(NSString *)ToASCIIString{
    return [[NSString alloc]initWithData:self encoding:NSASCIIStringEncoding];
}

-(NSString *)ToUtf8String{
    return [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
}

-(NSString *)ToGB2312String{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return [[NSString alloc]initWithData:self encoding:encoding];
}
@end
