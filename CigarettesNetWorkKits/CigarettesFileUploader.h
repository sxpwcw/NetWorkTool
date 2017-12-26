//
//  CigarettesFileUploader.h
//  CigarettesNetWorkKits
//
//  Created by Jack on 15/8/23.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CigarettesNetWorkKits.h"

typedef void(^Uploading)(float Percent,float ProcessBarValue);
typedef void(^Uploaded)(NSData *data,NSURLResponse *response,NSError *error);

@interface CigarettesFileUploader : CigarettesNetWorkTool

/**
 *  使用默认类型初始化一个网络访问类的实例
 *
 *  @return 返回初始化后的网络访问类的实例
 */
+(CigarettesFileUploader *)shardCigarettesFileUploader;

@property (nonatomic) NSArray *Files;


-(void)startUploadFile:(Uploading)uploadinghandler uploaded:(Uploaded)uploadedHandler;
@end
