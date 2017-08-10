//
//  BulletManager.h
//  CommentDemo
//
//  Created by 十月 on 16/9/21.
//  Copyright © 2016年 October. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuiletView;

@interface BulletManager : NSObject
//回调
@property (nonatomic,copy) void(^generateViewBlock)(BuiletView *view);


//弹幕开始执行
- (void)start;

//弹幕停止执行
- (void)stop;

@end
