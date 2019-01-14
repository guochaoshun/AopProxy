//
//  NSTimer+BlockTimer.m
//  测试
//
//  Created by gao on 2019/1/11.
//  Copyright © 2019年 gao. All rights reserved.
//

#import "NSTimer+BlockTimer.h"

@implementation NSTimer (BlockTimer)

+ (NSTimer *)gcs_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(gcs_block:) userInfo:block repeats:repeats];
}

+ (void)gcs_block:(NSTimer *)timer {
    void (^block)(NSTimer *timer) = timer.userInfo ;
    if (block) {
        block(timer);
    }
}


@end
