//
//  InterfaceController.h
//  NetWorkKitsTest WatchKit Extension
//
//  Created by Jack on 15/6/15.
//  Copyright (c) 2015年 Jack. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController
- (IBAction)Click;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *btn;

@end
