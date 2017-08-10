//
//  BulletManager.m
//  CommentDemo
//
//  Created by 十月 on 16/9/21.
//  Copyright © 2016年 October. All rights reserved.
//

#import "BulletManager.h"
#import "BulletView.h"

@interface BulletManager()
//弹幕的数据来源
@property (nonatomic, strong) NSMutableArray *dataSource;

//弹幕使用过程中的一个数组变量
@property (nonatomic, strong) NSMutableArray *bulletComments;

//存储弹幕View的数组变量
@property (nonatomic, strong) NSMutableArray *bulletViews;

@property BOOL bStopAnimation;
@end


@implementation BulletManager

- (instancetype)init{
    if (self = [super init]) {
        self.bStopAnimation = YES;
    }
    return self;
}

-(void)start{
    if (!self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = NO;
    [self.bulletComments removeAllObjects];
    [self.bulletComments addObjectsFromArray:self.dataSource];
    [self initBulletComment];
}


-(void)stop{
    if (self.bStopAnimation) {
        return;
    }
    self.bStopAnimation = YES;
    [self.bulletViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletView *view = obj;
        [view stopAnimation];
        view = nil;
    }];

    [self.bulletViews removeAllObjects];

}
//初始化弹幕 随机分配弹幕轨迹
- (void)initBulletComment{
    
    NSMutableArray *trajectorys = [NSMutableArray arrayWithArray:@[@(0),@(1),@(2)]];
    for (int i = 0; i < 3 ;i++ ) {
        if (self.bulletComments.count > 0) {
        //通过随机数获取到弹幕的轨迹
        NSInteger index = arc4random()%trajectorys.count;
        int trajectory  = [[trajectorys objectAtIndex:index] intValue];
        [trajectorys removeObjectAtIndex:index];
        
        //从弹幕数组中逐一取出弹幕数据
        NSString *comment = [self.bulletComments firstObject];
        [self.bulletComments removeObjectAtIndex:0];
        //创建弹幕的view 就是拿到弹幕和弹幕的轨迹
        [self createBulletView:comment trajectory:trajectory];
            
        }
    }
}

-(void)createBulletView:(NSString *)comment trajectory:(int)trajectory{
    if (self.bStopAnimation) {
        return;
    }
    BulletView *view = [[BulletView alloc] initWithComment:comment];
    view.trajectory = trajectory;
    [self.bulletViews addObject:view];
    //调用变量的时候对他修改了所以要使用__weak
    __weak typeof(view) weakView = view;
    __weak typeof(self) myself = self;
    view.moveStatusBlock = ^(MoveStatus status){
        if (self.bStopAnimation) {
            return ;
        }
        switch (status) {
            case Start:{
                //弹幕开始进入屏幕,将创建的view 加入到弹幕管理的变量中bulletViews
                [myself.bulletViews addObject:weakView];
                
                break;
            }
            case Enter:{
                //完全进入屏幕，判断是否还有其他内容如果有则在该弹幕轨迹中创建一个弹幕
                NSString *comment = [myself nextComment];
                if (comment) {
                    [myself createBulletView:comment trajectory:trajectory];
                }
                break;
            }
            case End:{
                //弹幕飞出屏幕以后从bulletViews中删除
                if ([myself.bulletViews containsObject:weakView]) {
                    [weakView stopAnimation];
                    [myself.bulletViews removeObject:weakView];
                    
                }
                if (myself.bulletViews.count ==0) {
                    //说明屏幕上没有弹幕的时候 开始滚动
                    myself.bStopAnimation = YES;
                    [myself start];
                }
                break;
            }
            default:
                break;
        }
    };
    
    if (self.generateViewBlock) {
        self.generateViewBlock(view);
    }
}

- (NSString *)nextComment{
    
    if (self.bulletComments.count == 0) {
        return nil;
    }
    
  NSString *comment = [self.bulletComments firstObject];
    if (comment) {
        [self.bulletComments removeObjectAtIndex:0];
    }
    return comment;
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:@[@"弹幕1+++++++",@"弹幕2~~~~~~~~~~~~~~~~~~~~~~~~~~~~",@"弹幕3~~~~~~~~~~~~~~",@"弹幕4+++++++",@"弹幕5~===~~~~~~~~~~~",@"弹幕6~~~~~~~"]];
        
    }
    return _dataSource;
}


- (NSMutableArray *)bulletComments{
    if (!_bulletComments) {
        _bulletComments = [NSMutableArray array];
        
    }
    return _bulletComments;
}

- (NSMutableArray *)bulletViews{
    if (!_bulletViews) {
        _bulletViews = [NSMutableArray array];
        
    }
    return _bulletViews;
}
@end
