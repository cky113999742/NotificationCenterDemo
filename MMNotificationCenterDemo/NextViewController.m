//
//  NextViewController.m
//  MMNotificationCenterDemo
//
//  Created by Cuikeyi on 2017/7/20.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "NextViewController.h"
#import "MMNotificationCenter.h"
#import "NextView.h"

@interface NextViewController ()

@property (nonatomic, strong) NextView *nextView;

@end

@implementation NextViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [[MMNotificationCenter defaultCenter] addObserver:self selector:@selector(notiAction:) name:@"test" object:nil];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 35)];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setBackgroundColor:[UIColor greenColor]];
    backButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *notiButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 150, 100, 35)];
    [notiButton setTitle:@"发送通知" forState:UIControlStateNormal];
    [notiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [notiButton setBackgroundColor:[UIColor greenColor]];
    notiButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [notiButton addTarget:self action:@selector(postNoti) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notiButton];
    
    _nextView = [[NextView alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    _nextView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_nextView];
}

- (void)postNoti
{
    [[MMNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)notiAction:(MMNotificationModel *)noti
{
    NSLog(@"%s", __func__);
}

@end
