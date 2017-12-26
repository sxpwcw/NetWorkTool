//
//  ViewController.m
//  NetWorkKitsTest
//
//  Created by Jack on 15/6/15.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import "ViewController.h"
#import <CigarettesNetWorkKits/CigarettesNetWorkKits.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn=(UIButton *)[self.view viewWithTag:90];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)click:(id)sender{
    NSMutableDictionary *postData=[[NSMutableDictionary alloc]init];
    [postData setValue:@"json" forKey:@"format"];
    [postData setValue:@"07010073" forKey:@"userid"];
    CigarettesNetWorkTool *tool=[CigarettesNetWorkTool shardCigarettesNetWorkTools];
    tool.Url=@"http://111.11.146.245:8080/picclp/mobile/NoCompleteNum";
    tool.parm=postData;
    tool.mothed=VisitModeGET;
    tool.CurrentApplication=[UIApplication sharedApplication];
    [tool startWithResultJSONArray:^(NSArray *JsonArrayResult) {
        NSLog(@"%@",[JsonArrayResult valueForKey:@"Name"]);
    } errorHandler:^(NSError *error) {
         NSLog(@"发生系统错误，信息为：%@",[error localizedDescription]);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
