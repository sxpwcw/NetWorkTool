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

@interface  CigarettesNetWorkTool()<NSURLSessionTaskDelegate>{
    NSURL *url;
    NSURLSession *session;
    NSURLRequest *request;
    NSString *UserAgent;
    float percent;
    Uploading uploadings;
}
@end

@implementation CigarettesNetWorkTool

+(CigarettesNetWorkTool *)shardCigarettesNetWorkTools{
    static CigarettesNetWorkTool *CLass=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CLass=[[super alloc]init];
        CLass.CurrentApplication=[UIApplication sharedApplication];
    });
    CLass.parm=nil;
    CLass.Url=nil;
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
    mutablerequest.HTTPShouldHandleCookies=NO;
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
        if([_Url rangeOfString:@"?"].length==0){
            mutablerequest.URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",_Url,[self buildParams]]];
        }else{
            mutablerequest.URL=[NSURL URLWithString:[NSString stringWithFormat:@"%@&%@",_Url,[self buildParams]]];
        }
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
                self->_CurrentApplication.networkActivityIndicatorVisible=NO;
            });
        }
    }];
    [task resume];
}
-(void)startWithResultJSONArray:(onCompleteWithJsonArray)handler errorHandler:(onNetWorkError)errorhandler{
    [self buildRequest];
    _CurrentApplication.networkActivityIndicatorVisible=YES;
    session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                errorhandler(error);
            }else{
                NSArray *resultArray=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                handler(resultArray);
            }
            self->_CurrentApplication.networkActivityIndicatorVisible=NO;
        });
        
    }];
    [task resume];
}
-(void)startWithResultStringInBackground:(onCompleteWithResultString)handler errorHandler:(onNetWorkError)errorhandler UrlSessionDelegate:(id)delegate{
    [self buildRequest];
    _CurrentApplication.networkActivityIndicatorVisible=YES;
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"BackgroundSession"];
    session=[NSURLSession sessionWithConfiguration:sessionConfig delegate:delegate delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                errorhandler(error);
            }else{
                if([response.textEncodingName.uppercaseString isEqualToString:@"GB2312"]||[response.textEncodingName.uppercaseString isEqualToString:@"GBK"]){
                    handler([data ToGB2312String]);
                }else{
                    handler([data ToUtf8String]);
                }
            }
            self->_CurrentApplication.networkActivityIndicatorVisible=NO;
        });
    }];
    [task resume];
}
-(void)start:(onNetWorkCompleteHandler)handler errorHandler:(onNetWorkError)errorhandler{
    [self buildRequest];
    _CurrentApplication.networkActivityIndicatorVisible=YES;
    session=[NSURLSession sharedSession];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(error){
                errorhandler(error);
            }else{
                handler(data,response);
            }
            self->_CurrentApplication.networkActivityIndicatorVisible=NO;
        });
    }];
    [task resume];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend{
    float progress = (float)totalBytesSent / totalBytesExpectedToSend;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSNumberFormatter *format = [[NSNumberFormatter alloc]init];
        [format setNumberStyle:NSNumberFormatterDecimalStyle];
        [format setRoundingMode:NSNumberFormatterRoundHalfUp];
        [format setMaximumFractionDigits:0];
        self->percent=progress*100;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->uploadings(self->percent-1,progress-0.01);
        });
    });
}
-(void)startUploadFile:(Uploading)uploadinghandler uploaded:(Uploaded)uploadedHandler{
    uploadings=uploadinghandler;
    [self buildRequest];
    _CurrentApplication.networkActivityIndicatorVisible=YES;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if(uploadedHandler){
                    uploadedHandler(data,response,error);
                }
                self->uploadings(100,1);
            });
            self->_CurrentApplication.networkActivityIndicatorVisible=NO;
        });
    }];
    [task resume];
}
@end
