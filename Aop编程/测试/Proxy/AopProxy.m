//
//  AopProxy.m
//  测试
//
//  Created by gao on 2019/1/11.
//  Copyright © 2019年 gao. All rights reserved.
//

#import "AopProxy.h"

@interface AopProxy ()

@property (nonatomic,strong) NSMutableDictionary * preDic ;
@property (nonatomic,strong) NSMutableDictionary * afterDic ;

@end

@implementation AopProxy



+(id)proxyWithObj:(id)object {
    return [[self alloc] initWithObj:object];
}
- (id)initWithObj:(id)object {
    // 要hook的对象
    self.obj = object;
    self.preDic = [NSMutableDictionary dictionary];
    self.afterDic = [NSMutableDictionary dictionary];
    return self;
}

- (void)addSelector:(SEL)sel withPreAction:(actionBlock)preAction afterAction:(actionBlock)afterAction {
    
    NSString * key = NSStringFromSelector(sel);
    if (preAction) {
        self.preDic[key] = preAction;
    }
    if (afterAction) {
        self.afterDic[key] = afterAction;
    }

}



- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    //这里可以返回任何NSMethodSignature对象，你也可以完全自己构造一个
    return [self.obj methodSignatureForSelector:sel];
}
- (void)forwardInvocation:(NSInvocation *)invocation{
    
    if([self.obj respondsToSelector:invocation.selector] == NO){
        return;
    }
        // 打印invocation的信息,放开这行会崩
//    [self log_forwardInvocation:invocation];
    
    // 前面切一刀
    NSString * key = NSStringFromSelector(invocation.selector);
    if (self.preDic[key]) {
        actionBlock preAction = self.preDic[key];
        preAction(self.obj,invocation.selector);
    }
    
    //消息转发
    [invocation invokeWithTarget:self.obj];
    
    // 后面切一刀
    if (self.afterDic[key]) {
        actionBlock afterAction = self.afterDic[key];
        afterAction(self.obj,invocation.selector);
    }
    
}

/// 打印参数 , 不知道为什么 , 当我选择打印入参和返回值, 在打印结束后,就会报野指针错误
- (void)log_forwardInvocation:(NSInvocation *)invocation {
    
    NSString *selectorName = NSStringFromSelector(invocation.selector);
    NSLog(@"Before calling  %@",selectorName);
    NSMethodSignature *sig = [invocation methodSignature];
    if (invocation.argumentsRetained == NO) {
        [invocation retainArguments];        
    }
    //获取参数个数，注意再本例里这里的值是3，为什么呢？
    //因为objc_msgSend的前两个参数是隐含的
    NSUInteger cnt = [sig numberOfArguments];
    //本例只是简单的将参数和返回值打印出来
    for (int i = 0; i < cnt; i++) {
        const char * type = [sig getArgumentTypeAtIndex:i];
        if(strcmp(type, "@") == 0){
            NSObject *obj;
            [invocation getArgument:&obj atIndex:i];
            //这里输出的是："parameter (0)'class is MyProxy"
            //也证明了这是objc_msgSend的第一个参数
            NSLog(@"parameter (%d)'class is %@",i,[obj class]);
        }
        else if(strcmp(type, ":") == 0){
            SEL sel;
            [invocation getArgument:&sel atIndex:i];
            //这里输出的是:"parameter (1) is barking:"
            //也就是objc_msgSend的第二个参数
            NSLog(@"parameter (%d) is %@",i,NSStringFromSelector(sel));
        }
        else if(strcmp(type, "q") == 0){
            int arg = 0;
            [invocation getArgument:&arg atIndex:i];
            //这里输出的是:"parameter (2) is int value is 4"
            //稍后会看到我们再调用barking的时候传递的参数就是4
            NSLog(@"parameter (%d) is int value is %d",i,arg);
        }
    }
    
    const char *retType = [sig methodReturnType];
    if(strcmp(retType, "@") == 0){
        NSObject *ret;
        [invocation getReturnValue:&ret];
        //这里输出的是:"return value is wang wang!"
        NSLog(@"return value is %@",ret);
    }
    NSLog(@"After calling %@",selectorName);
    
    
    
}



- (void)dealloc {

    NSLog(@"%@ dealloc",self);
    
}










@end
