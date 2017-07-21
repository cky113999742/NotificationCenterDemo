//
//  MMNotificationCenter.m
//  TestDemo
//
//  Created by Cuikeyi on 2017/7/20.
//  Copyright © 2017年 wemomo.com. All rights reserved.
//

#import "MMNotificationCenter.h"

@interface MMNotificationCenter ()

@property (nonatomic, strong) NSMutableDictionary *cacheDict;

@end

@implementation MMNotificationCenter

+ (MMNotificationCenter *)defaultCenter
{
    static MMNotificationCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[MMNotificationCenter alloc] init];
    });
    return center;
}

- (instancetype)init
{
    if (self = [super init]) {
        _cacheDict = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 添加
- (void)addObserver:(id)target selector:(SEL)sel name:(MMNotificationName)name object:(NSObject *)object
{
    if (!target) return;
    if (!name) return;
    
    MMNotificationModel *model = [[MMNotificationModel alloc] init];
    model.observer = target;
    model.selector = sel;
    model.notificationName = name;
    model.object = object;
    NSMutableArray *array = [[_cacheDict objectForKey:name] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    [array addObject:model];
    [_cacheDict setObject:array forKey:name];
}

- (id)addObserverForName:(MMNotificationName)name object:(id)object queue:(NSOperationQueue*)queue usingBlock:(MMNotificationBlock)block
{
    MMNotificationModel *model = [[MMNotificationModel alloc] init];
    model.notificationName = name;
    model.object = object;
    model.operationQueue = queue;
    model.block = block;
    NSMutableArray *array = [[_cacheDict objectForKey:name] mutableCopy];
    if (!array) {
        array = [NSMutableArray array];
    }
    [array addObject:model];
    [_cacheDict setObject:array forKey:name];
    return model;
}

#pragma mark - 发送
- (void)postNotification:(MMNotificationModel *)notification
{
    MMNotificationName name = notification.notificationName;
    if (!name) return;
    NSMutableArray *notiArray = [[_cacheDict objectForKey:name] mutableCopy];
    
    [notiArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMNotificationModel *observerModel = (MMNotificationModel *)obj;
        id observer = observerModel.observer;
        SEL selector = observerModel.selector;
        // 失效通知检查
        if (!observer && !observerModel.block) {// 没有观察者&&没有实现block，那么认为这个通知已经失效
            [notiArray removeObject:observerModel];
            [_cacheDict setObject:notiArray forKey:name];
            // 此处的 return 是结束此次循环，进行下一次，类似于 for 和 while 中的 continue 一样
            return ;
        }
        
        void (^postBlock)() = ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if (observer) {
                [observer performSelector:selector withObject:notification];
            }
            if (observerModel.block) {
                observerModel.block(notification);
            }
#pragma clang diagnostic pop
        };
        
        if (!observerModel.operationQueue) {
            postBlock();
        }
        else {
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                postBlock();
            }];
            NSOperationQueue *operationQueue = observerModel.operationQueue;
            [operationQueue addOperation:operation];
        }
    }];
}

- (void)postNotificationName:(MMNotificationName)aName object:(id)anObject
{
    MMNotificationModel *model = [[MMNotificationModel alloc] init];
    model.notificationName = aName;
    model.object = anObject;
    [self postNotification:model];
}

- (void)postNotificationName:(MMNotificationName)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
    MMNotificationModel *model = [[MMNotificationModel alloc] init];
    model.notificationName = aName;
    model.object = anObject;
    model.userInfo = aUserInfo;
    [self postNotification:model];
}

#pragma mark - 移除 
// 这种移除方式的数据结构有待优化，此处的时间复杂度较高，暂时没有想到更好的方法。
- (void)removeObserver:(id)observer
{
    if (!observer) return;
    [_cacheDict.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = (NSString *)obj;
        NSMutableArray *array = [[_cacheDict objectForKey:name] mutableCopy];
        [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MMNotificationModel *observerModel = (MMNotificationModel *)obj;
            if (observerModel.observer && observer == observerModel.observer) {// 使用sel添加
                [array removeObject:observerModel];
            }
            else if (observerModel.block && observerModel == observer) {
                [array removeObject:observerModel];
            }
        }];
        [_cacheDict setObject:array forKey:name];
    }];
}

- (void)removeObserver:(id)observer name:(MMNotificationName)aName object:(id)anObject
{
    if (!observer) return;
    if (!aName) return;
    NSMutableArray *array = [[_cacheDict objectForKey:aName] mutableCopy];
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MMNotificationModel *observerModel = (MMNotificationModel *)obj;
        if (observer == observerModel.observer && anObject == observerModel.object) {
            [array removeObject:observerModel];
        }
        else if (observerModel.block && [observerModel.notificationName isEqualToString:aName] && observer == observerModel) {
            [array removeObject:observerModel];
        }
    }];
    [_cacheDict setObject:array forKey:aName];
}

@end
