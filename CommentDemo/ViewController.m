//
//  ViewController.m
//  CommentDemo
//
//  Created by 十月 on 16/9/21.
//  Copyright © 2016年 October. All rights reserved.
//

#import "ViewController.h"
#import "BulletManager.h"
#import "BulletView.h"

@interface ViewController ()
@property(nonatomic, strong) BulletManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[BulletManager alloc] init];
    __weak typeof (self) myself = self;
    self.manager.generateViewBlock = ^(BuiletView *view){
        [myself addBulletView:view];
    };
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"start" forState:UIControlStateNormal];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnS  = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnS setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnS setTitle:@"stop" forState:UIControlStateNormal];
    btnS.frame = CGRectMake(250, 100, 100, 40);
    [btnS addTarget:self action:@selector(clickStopBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnS];

    
}
- (void)addBulletView:(BulletView *)view{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    view.frame = CGRectMake(width, 300+view.trajectory *40, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    [self.view addSubview:view];
    [view starAnimation];
    
}
#pragma mark - 停止
- (void)clickStopBtn{
    [self.manager stop];
}

#pragma mark - 开始
- (void)clickBtn{
    [self.manager start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
