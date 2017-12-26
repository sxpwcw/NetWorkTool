//
//  CigarettesNetWorkTool.h
//  CigarettesNetWorkKits
//
//  Created by Jack on 15/6/15.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  网络访问类型
 */
typedef NS_ENUM(NSInteger, VisitMode){
    /**
     *  DELETE
     */
    VisitModeDELETE = 3,
    /**
     *  GET
     */
    VisitModeGET = 0,
    /**
     *  HEAD
     */
    VisitModeHEAD = 4,
    /**
     *  OPTIONS
     */
    VisitModeOPTIONS = 5,
    /**
     *  PATCH
     */
    VisitModePATCH = 6,
    /**
     *  POST
     */
    VisitModePOST = 1,
    /**
     *  PUT
     */
    VisitModePUT = 2,
};
typedef void(^Uploading)(float Percent,float ProcessBarValue);
typedef void(^Uploaded)(NSData *data,NSURLResponse *response,NSError *error);
/**
 *  网络请求处理成功后返回的信息闭包
 *
 *  @param data     网络返回的数据
 *  @param Response NSURLResponse的实例
 */
typedef void(^onNetWorkCompleteHandler)(NSData *data,NSURLResponse *Response);
/**
 *  网络请求错误返回的闭包
 *
 *  @param error 错误类型对象
 */
typedef void(^onNetWorkError)(NSError *error);
/**
 *  网络访问完成后返回一个字符串信息的闭包
 *
 *  @param result 字符串
 */
typedef void(^onCompleteWithResultString)(NSString *result);
/**
 *  网络访问完成后返回一个JSON对象信息的闭包
 *
 *  @param JsonArrayResult JSON对象
 */
typedef void(^onCompleteWithJsonArray)(NSArray *JsonArrayResult);
/**
 *  表示自定义网络访问类
 */
@interface CigarettesNetWorkTool : NSObject
/**
 *  获取或者设置一个值，该值表示网络访问请求的URL地址
 */
@property (nonatomic , copy) NSString *Url;
/**
 *  获取或者设置一个值，该值表示超时时间改时间默认为50秒
 */
@property (nonatomic) NSTimeInterval TimeOut;
/**
 *  获取或者设置一个值，该值表示请求参数
 */
@property (nonatomic , copy) NSDictionary *parm;
/**
 *  获取或者设置一个值，该值表示请求方式
 */
@property (nonatomic) VisitMode mothed;
/**
 *  获取或者设置一个值，该值表示当前的应用程序类型的实例
 */
@property (nonatomic) UIApplication *CurrentApplication;
/**
 *  使用默认类型初始化一个网络访问类的实例
 *
 *  @return 返回初始化后的网络访问类的实例
 */
+(CigarettesNetWorkTool *)shardCigarettesNetWorkTools;

/**
 *  开始网络访问，并返回执行完成之后的闭包，该闭包返回一个字符串
 *
 *  @param handler      网络访问完成后返回一个字符串信息的闭包
 *  @param errorhandler 网络请求错误返回的闭包
 */
-(void)startWithResultString:(onCompleteWithResultString)handler errorHandler:(onNetWorkError)errorhandler;
/**
 *  开始网络访问，并返回执行完成之后的闭包，该闭包返回一个JSON数组
 *
 *  @param handler      网络访问完成后返回一个JSON信息的闭包
 *  @param errorhandler 网络请求错误返回的闭包
 */
-(void)startWithResultJSONArray:(onCompleteWithJsonArray)handler errorHandler:(onNetWorkError)errorhandler;
/**
 *  开始网络访问，并将其置于后台，成功后返回一个闭包，该闭包返回一个字符串
 *
 *  @param handler      网络访问完成后返回一个字符串信息的闭包
 *  @param errorhandler 网络请求错误返回的闭包
 *  @param delegate     NSURLSESSION的代理类
 */
-(void)startWithResultStringInBackground:(onCompleteWithResultString)handler errorHandler:(onNetWorkError)errorhandler UrlSessionDelegate:(id)delegate;
/**
 *  开始网络访问，并返回执行完成之后的闭包,该闭包返回一个网络访问请求的NSData对象
 *
 *  @param handler      网络请求处理成功后返回的信息闭包
 *  @param errorhandler 网络请求错误返回的闭包
 */
-(void)start:(onNetWorkCompleteHandler)handler errorHandler:(onNetWorkError)errorhandler;

-(void)startUploadFile:(Uploading)uploadinghandler uploaded:(Uploaded)uploadedHandler;
@end
