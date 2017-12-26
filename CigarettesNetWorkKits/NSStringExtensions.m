//
//  NSStringExtensions.m
//  CigarettesNetWorkKits
//
//  Created by Jack on 15/6/15.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import "NSStringExtensions.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (NSStringExtensions)

-(NSData *)ToData{
    return  [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
}

-(NSString *)ToBase64{
    NSData *data=[self ToData];
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
-(NSString *)CutLastString{
    return [self substringToIndex:[self length]-1];
}
-(NSString *)Trim{
    return [[self stringByReplacingOccurrencesOfString:@" " withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}
-(NSString *)CutLastStringWithString:(NSString *)opt{
    if([[self substringFromIndex:[self length]-1] isEqualToString:opt]){
        return [self CutLastString];
    }
    return self;
}
-(NSString *)ToMd5{
    const char *CSTR=[self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    long strLength=strlen(CSTR);
    CC_MD5(CSTR,(CC_LONG)strLength,result);
    NSMutableString *RET=[[NSMutableString alloc]initWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger index=0; index<CC_MD5_DIGEST_LENGTH; index++) {
        [RET appendFormat:@"%02X",result[index]];
    }
    return [RET uppercaseString];
}
-(UIColor *)colorHexStringWithalpha:(float)_alpha
{
    NSString *cString = [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:_alpha];
}
-(NSString *)EncodeUrlString{
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                     (CFStringRef)self,
                                                                     NULL,
                                                                     CFSTR(":/?#[]@!$&’()*+,;="),
                                                                     kCFStringEncodingUTF8));
}
@end
