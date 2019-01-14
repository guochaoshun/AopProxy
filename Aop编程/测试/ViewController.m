//
//  ViewController.m
//  测试
//
//  Created by gao on 2019/1/7.
//  Copyright © 2019年 gao. All rights reserved.
//

#import "ViewController.h"
#import "AopProxy.h"
#import <objc/runtime.h>
#import "SecondViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 可以把这个hookedView的方法横着切了出去,切系统的单个对象方法很舒服的,不适用某个类的所有对象,那还是使用method_exchangeImplementations比较好
    UIView * hookedView = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)] ;
    hookedView.backgroundColor = [UIColor redColor];
    UIView * proxy = [AopProxy proxyWithObj: hookedView ];
    [(AopProxy *)proxy addSelector:@selector(viewWithTag:) withPreAction:^(id target, SEL sel) {
        NSLog(@"%@调用%@之前",[target class],NSStringFromSelector(sel));
    } afterAction:^(id target, SEL sel) {
        NSLog(@"%@调用%@之后",[target class],NSStringFromSelector(sel));
    }];
    [proxy viewWithTag:100];
    [proxy viewWithTag:222];

    
    // 不会调block,因为发消息的对象不对
    [hookedView viewWithTag:200];
    // 不会调block,因为没有注册这个sel
    [proxy canBecomeFirstResponder];

    [self.view addSubview:hookedView];
    
}

/// 用Proxy解决timer的强应用
- (IBAction)gotoTimerVc:(id)sender {
    
    SecondViewController * sec = [[SecondViewController alloc] init];
    [self.navigationController pushViewController:sec animated:YES];
    
}


@end
