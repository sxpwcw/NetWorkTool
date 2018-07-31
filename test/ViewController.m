//
//  ViewController.m
//  test
//
//  Created by ChengWuWang on 2018/7/31.
//  Copyright © 2018年 Jack. All rights reserved.
//

#import "ViewController.h"
#import "CigarettesNetWorkKits.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CigarettesNetWorkTool *tool=[CigarettesNetWorkTool new];
    tool.Url=@"http://app.qilongs.com/?app=appapi&controller=discovery&action=index&page=1";
    tool.mothed=VisitModeGET;
    tool.CurrentApplication=[UIApplication sharedApplication];
    [tool startWithResultJSONArray:^(NSArray *JsonArrayResult) {
        NSLog(@"%@",JsonArrayResult);
    } errorHandler:^(NSError *error) {
        
    }];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
