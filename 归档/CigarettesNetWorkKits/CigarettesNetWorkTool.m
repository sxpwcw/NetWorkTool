//
//  CigarettesNetWorkTool.m
//  CigarettesNetWorkKits
//
//  Created by Jack on 15/6/15.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import "CigarettesNetWorkTool.h"
#import "NSDataExtensions.h"
#import "NSStringExtensions.h"

@interface  CigarettesNetWorkTool(){
    NSURL *url;
    NSURLSession *session;
    NSURLRequest *request;
    NSString *UserAgent;
}
@end

@implementation CigarettesNetWorkTool

+(CigarettesNetWorkTool *)shardCigarettesNetWorkTools{
    static CigarettesNetWorkTool *CLass=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CLass=[[super alloc]init];
    });
    return CLass;
}
-(NSString*)buildUserAgent{
    NSDictionary *info=[[NSBundle mainBundle]infoDictionary];
    NSString* executable=info[(NSString *)kCFBundleExecutableKey]?info[(NSString *)kCFBundleExecutableKey]:@"Unknown";
    NSString* bundle=info[(NSString*)kCFBundleIdentifierKey]?info[(NSString*)kCFBundleIdentifierKey]:@"Unknown";
    NSString* version=info[(NSString*)kCFBundleVersionKey]?info[(NSString*)kCFBundleVersionKey]:@"Unknown";
    NSString* os=[NSProcessInfo processInfo].operatingSystemVersionString?[NSProcessInfo processInfo].operatingSystemVersionString:@"Unknown";
    CFMutableStringRef string=(__bridge CFMutableStringRef)[NSMutableString stringWithFormat:@"%@/%@ (%@; OS (%@))",executable,bundle,version,os];
    CFStringRef transform=(__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove";
    if(CFStringTransform(string, nil, transform, 0)==1){
        return (__bridge NSString *)string;
    }else{
        return @"";
    }
}
-(void)buildRequest{
    NSMutableURLRequest *mutablerequest=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:_Url]];
    mutablerequest.timeoutInterval=self.TimeOut>0?self.TimeOut:50;
    switch (_mothed) {
        case VisitModePOST:
            mutablerequest.HTTPMethod=@"POST";
            break;
        case VisitModeGET:
            mutablerequest.HTTPMethod=@"GET";
            break;
        default:
            mutablerequest.HTTPMethod=@"GET";
            break;
    }
    [mutablerequest addValue:[self buildUserAgent] forHTTPHeaderField:@"User-Agent"];
    if([self.parm count]>0&&_mothed==VisitModePOST){
        mutablerequest.HTTPBody=[[self buildParams] ToData];
    }else if([self.parm count]>0&&_mothed==VisitModeGET){
        mutablerequest.URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",_Url,[self buildParams]]];
    }
    request=[mutablerequest copy];
}
-(NSString *)buildParams{
    NSMutableString *mutableStr=[[NSMutableString alloc]init];
    for (NSString *key in [self.parm allKeys]){
        [mutableStr appendString:[NSString stringWithFormat:@"%@=%@&",key,[self.parm valueForKey:key]]];
    }
    return [mutableStr CutLastString];
}
-(void)startWithResultString:(onCompleteWithResultString)handler errorHandler:(onNetWorkError)errorhandler{
    [self buildRequest];
    _CurrentApplication.networkActivityIndicatorVisible=YES;
    session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            errorhandler(error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if([response.textEncodingName.uppercaseString isEqualToString:@"GB2312"]||[response.textEncodingName.uppercaseString isEqualToString:@"GBK"]){
                    handler([data ToGB2312String]);
                }else{
                    handler([data ToUtf8String]);
                }
            });
            _CurrentApplication.networkActivityIndicatorVisible=NO;
        }
    }];
    [task resume];
}
-(void)startWithResultJSONArray:(onCompleteWithJsonArray)handler errorHandler:(onNetWorkError)errorhandler{
    [self buildRequest];
    _CurrentApplication.networkActivityIndicatorVisible=YES;
    session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            errorhandler(error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *resultArray=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                handler(resultArray);
            });
            _CurrentApplication.networkActivityIndicatorVisible=NO;
        }
    }];
    [task resume];
}
-(void)startWithResultStringInBackground:(onCompleteWithResultString)handler errorHandler:(onNetWorkError)errorhandler UrlSessionDelegate:(id)delegate{
    [self buildRequest];
    _CurrentApplication.networkActivityIndicatorVisible=YES;
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"BackgroundSession"];
    session=[NSURLSession sessionWithConfiguration:sessionConfig delegate:delegate delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            errorhandler(error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if([response.textEncodingName.uppercaseString isEqualToString:@"GB2312"]||[response.textEncodingName.uppercaseString isEqualToString:@"GBK"]){
                    handler([data ToGB2312String]);
                }else{
                    handler([data ToUtf8String]);
                }
            });
            _CurrentApplication.networkActivityIndicatorVisible=NO;
        }
    }];
    [task resume];
}
-(void)start:(onNetWorkCompleteHandler)handler errorHandler:(onNetWorkError)errorhandler{
    [self buildRequest];
    _CurrentApplication.networkActivityIndicatorVisible=YES;
    session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            errorhandler(error);
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(data,response);
            });
        }
        _CurrentApplication.networkActivityIndicatorVisible=NO;
    }];
    [task resume];
}
@end
