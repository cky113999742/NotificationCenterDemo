//
//  MMNotificationModel.h
//  TestDemo
//
//  Created by Cuikeyi on 2017/7/20.
//  Copyright © 2017年 wemomo.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MMNotificationModel;

typedef void(^MMNotificationBlock)(MMNotificationModel *notification);
typedef NSString *MMNotificationName;

@interface MMNotificationModel : NSObject

@property (nonatomic, weak) id observer;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, copy) MMNotificationName notificationName;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, copy) MMNotificationBlock block;
@property (nonatomic, strong) NSDictionary *userInfo;

@end
