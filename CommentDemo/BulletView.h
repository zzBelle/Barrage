//
//  BulletView.h
//  CommentDemo
//
//  Created by 十月 on 16/9/21.
//  Copyright © 2016年 October. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger , MoveStatus) {
    Start,
    Enter,
    End
};

@interface BulletView : UIView
@property (nonatomic,assign) int trajectory; //弹道
@property (nonatomic,copy) void(^moveStatusBlock)(MoveStatus status);//弹幕的回调
//初始化弹幕
-(instancetype)initWithComment:(NSString *)comment;
//开始动画
- (void)starAnimation;

//结束动画
- (void)stopAnimation;


@end
