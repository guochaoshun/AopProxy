//
//  AopProxy.h
//  测试
//
//  Created by gao on 2019/1/11.
//  Copyright © 2019年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^actionBlock)(id target , SEL sel);

NS_ASSUME_NONNULL_BEGIN

@interface AopProxy : NSProxy

@property (nonatomic,strong)id obj;

+(id)proxyWithObj:(id)object ;

- (void)addSelector:(SEL)sel withPreAction:(actionBlock)preAction afterAction:(actionBlock)afterAction ;

@end

NS_ASSUME_NONNULL_END
