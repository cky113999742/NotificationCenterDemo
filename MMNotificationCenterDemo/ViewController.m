//
//  ViewController.m
//  MMNotificationCenterDemo
//
//  Created by Cuikeyi on 2017/7/20.
//  Copyright © 2017年 MOMO. All rights reserved.
//

#import "ViewController.h"
#import "MMNotificationCenter.h"
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initView];
}

- (void)initView
{
    UIButton *notiButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 35)];
    [notiButton setTitle:@"发送通知" forState:UIControlStateNormal];
    [notiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [notiButton setBackgroundColor:[UIColor greenColor]];
    notiButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [notiButton addTarget:self action:@selector(postNoti) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notiButton];
    
    UIButton *nextPageButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 155, 100, 35)];
    [nextPageButton setTitle:@"下一页" forState:UIControlStateNormal];
    [nextPageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextPageButton setBackgroundColor:[UIColor greenColor]];
    nextPageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [nextPageButton addTarget:self action:@selector(gotoNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextPageButton];
}

- (void)postNoti
{
    [[MMNotificationCenter defaultCenter] postNotificationName:@"test" object:nil];
}

- (void)gotoNextPage
{
    NextViewController *vc = [[NextViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
