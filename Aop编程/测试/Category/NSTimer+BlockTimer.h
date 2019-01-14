//
//  NSTimer+BlockTimer.h
//  测试
//
//  Created by gao on 2019/1/11.
//  Copyright © 2019年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (BlockTimer)

+ (NSTimer *)gcs_scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block ;



@end

NS_ASSUME_NONNULL_END
