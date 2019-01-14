//
//  TimerProxy.m
//  测试
//
//  Created by gao on 2019/1/11.
//  Copyright © 2019年 gao. All rights reserved.
//

#import "TimerProxy.h"

@implementation TimerProxy



/**
 这个函数让重载方有机会抛出一个函数的签名，再由后面的forwardInvocation:去执行
 为给定消息提供参数类型信息
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [self.obj methodSignatureForSelector:aSelector];
}

/**
 *  NSInvocation封装了NSMethodSignature，通过invokeWithTarget方法将消息转发给其他对象.这里转发给控制器执行。
 */
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    [anInvocation invokeWithTarget:self.obj];
}


- (void)dealloc {
    NSLog(@"%@ %@",self,NSStringFromSelector(_cmd));
}



@end
