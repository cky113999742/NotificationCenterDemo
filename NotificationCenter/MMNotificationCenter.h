//
//  MMNotificationCenter.h
//  TestDemo
//
//  Created by Cuikeyi on 2017/7/20.
//  Copyright © 2017年 wemomo.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMNotificationModel.h"

@interface MMNotificationCenter : NSObject

+ (MMNotificationCenter *)defaultCenter;

#pragma mark - 添加
- (void)addObserver:(id)target selector:(SEL)sel name:(MMNotificationName)name object:(NSObject *)object;

/**
 使用此方法添加通知时，会返回一个 MMNotificationModel 对象，使用者需要保存这个 MMNotificationModel 对象，界面释放或者销毁的时候，需要手动移除 MMNotificationModel 并释放。
 （和系统的操作方法一致）
 eg: @property (nonatomic, strong) id observer;
    // 释放时候，代码如下👇
     if (_observer) {
         [[MMNotificationCenter defaultCenter] removeObserver:_observer];
         _observer = nil;
     }
 */
- (id)addObserverForName:(MMNotificationName)name object:(id)object queue:(NSOperationQueue*)queue usingBlock:(MMNotificationBlock)block;

#pragma mark - 发送
- (void)postNotification:(MMNotificationModel *)notification;
- (void)postNotificationName:(MMNotificationName)aName object:(id)anObject;
- (void)postNotificationName:(MMNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

#pragma mark - 移除
- (void)removeObserver:(id)observer;
- (void)removeObserver:(id)observer name:(MMNotificationName)aName object:(id)anObject;

@end
