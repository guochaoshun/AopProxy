//
//  SecondViewController.m
//  测试
//
//  Created by gao on 2019/1/11.
//  Copyright © 2019年 gao. All rights reserved.
//

#import "SecondViewController.h"
#import "TimerProxy.h"
#import "NSTimer+BlockTimer.h"

@interface SecondViewController ()

@property (nonatomic,strong) NSTimer * timer ;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多种方式解决timer的强应用";
    // 方式1
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    
    // 方法2
    TimerProxy * proxy = [TimerProxy alloc];
    proxy.obj = self;
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:proxy selector:@selector(run) userInfo:nil repeats:YES];
    
    
    // 方式3
//    [self.timer invalidate];
//    __weak typeof(self) weakSelf = self;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        // 用self还是会有强应用,得用weakSelf
////        [self run];
//        [weakSelf run];
//    }];
    // 方式3.1 变种
//    [self.timer invalidate];
//    __weak typeof(self) weakSelf = self;
//    self.timer = [NSTimer gcs_scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        // 用self还是会有强应用,得用weakSelf
////                [self run];
//        [weakSelf run];
//    }];
    
}

- (void)run {
    NSLog(@"scheduledTimerWithTimeInterval");
}



// 方式1 , 推荐,也可以写在viewWillDisappear
//- (void)willMoveToParentViewController:(UIViewController *)parent {
//    NSLog(@"willMoveToParentViewController %@",parent);
//}
//- (void)didMoveToParentViewController:(UIViewController *)parent{
//    NSLog(@"didMoveToParentViewController %@",parent);
//    if (parent == nil) {
//        [self.timer invalidate];
//    }
//
//}

- (void)dealloc {
    // 方式2,这句invalidate必须写上,不然会崩溃 , timer强引用着proxy,会继续给 [proxy run] , proxy没有run方法,报[NSProxy doesNotRecognizeSelector:run]崩溃
    // 方式3,也需要这句(不会崩),因为timer虽然没有了循环应用,但是还是在runloop中,只是一直给nil发消息,不执行而已
    [self.timer invalidate];
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
}



@end
