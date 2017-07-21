//
//  NextView.m
//  MMNotificationCenterDemo
//
//  Created by Cuikeyi on 2017/7/20.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "NextView.h"
#import "MMNotificationCenter.h"

@interface NextView ()

@property (nonatomic, strong) id observer;

@end

@implementation NextView

static int flag = 0;

- (void)dealloc
{
    [self viewWillDealloc];
    NSLog(@"%s", __func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        __weak typeof(self) weakSelf = self;
        _observer = [[MMNotificationCenter defaultCenter] addObserverForName:@"test" object:nil queue:queue usingBlock:^(MMNotificationModel *notification) {
            weakSelf.backgroundColor = flag%2?[UIColor orangeColor]:[UIColor yellowColor];
            flag++;
            NSLog(@"%s", __func__);
        }];
    }
    return self;
}

// 界面要退出时，需要调用这个方法
- (void)viewWillDealloc
{
    // 如果不使用这种方式，即使 NextView 被释放，通知的回调还是会存在
    if (_observer) {
        [[MMNotificationCenter defaultCenter] removeObserver:_observer];
        _observer = nil;
    }
}

@end
