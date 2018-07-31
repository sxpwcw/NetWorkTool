//
//  CigarettesFileUploader.m
//  CigarettesNetWorkKits
//
//  Created by Jack on 15/8/23.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import "CigarettesFileUploader.h"
@interface CigarettesFileUploader()<NSURLSessionTaskDelegate>{
    float percent;
    NSData *_data;
    NSURLResponse *_response;
    NSError *httperror;
    Uploading uploadings;
}
@end

@implementation CigarettesFileUploader

+(CigarettesFileUploader *)shardCigarettesFileUploader{
    static CigarettesFileUploader *CLass=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CLass=[[super alloc]init];
    });
    return CLass;
}
-(void)startUploadFile:(Uploading)uploadinghandler uploaded:(Uploaded)uploadedHandler{
    uploadings=uploadinghandler;
    [super CurrentApplication].networkActivityIndicatorVisible=YES;
    NSURL *url=[NSURL URLWithString:[super Url]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:0 timeoutInterval:10.0f];
    request.HTTPMethod=@"POST";
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc]init]];
    // 需要监听任务的执行状态
    for(NSString *FileUrl in self.Files){
        NSURLSessionUploadTask *task=[session uploadTaskWithRequest:request fromFile:[NSURL URLWithString:FileUrl] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(uploadedHandler){
                    uploadedHandler(data,response,error);
                }
                self->uploadings(100,1);
                [super CurrentApplication].networkActivityIndicatorVisible=NO;
            });
        }];
        [task resume];
    }
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
@end
