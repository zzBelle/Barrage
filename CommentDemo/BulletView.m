//
//  BulletView.m
//  CommentDemo
//
//  Created by 十月 on 16/9/21.
//  Copyright © 2016年 October. All rights reserved.
//

#import "BulletView.h"
#define Padding 10
#define PhotoHeight 30


@interface  BulletView()

@property(nonatomic, strong) UILabel *lbComment;
@property(nonatomic, strong) UIImageView *photoIgv;

@end

@implementation BulletView

- (UILabel *)lbComment{
    if (!_lbComment) {
        _lbComment = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbComment.font = [UIFont systemFontOfSize:14];
        _lbComment.textColor = [UIColor whiteColor];
        _lbComment.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbComment];
    }
    return _lbComment;
}


- (UIImageView *)photoIgv{
    if (!_photoIgv) {
        _photoIgv = [UIImageView new];
        _photoIgv.clipsToBounds = YES;
        _photoIgv.contentMode = UIViewTintAdjustmentModeNormal;
        [self addSubview:_photoIgv];
    }
    return _photoIgv;
}


//初始化弹幕
-(instancetype)initWithComment:(NSString *)comment{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = 14;
        //计算弹幕的实际宽度
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGFloat width = [comment sizeWithAttributes:attr].width;
        self.bounds = CGRectMake(0, 0, width + 2 * Padding+PhotoHeight, 30);
        self.lbComment.text = comment;
        self.lbComment.frame = CGRectMake(Padding + PhotoHeight, 0, width, 30);
        self.photoIgv.frame = CGRectMake(-Padding, -Padding, PhotoHeight + Padding, PhotoHeight + Padding);
        self.photoIgv.layer.cornerRadius = (PhotoHeight + Padding)/2;
        self.photoIgv.layer.borderColor = [UIColor whiteColor].CGColor;
        self.photoIgv.layer.borderWidth = 1;
        self.photoIgv.image = [UIImage imageNamed:@"headImage"];
        
    }
    return self;
}


//开始动画
- (void)starAnimation{
    //根据弹幕的长度执行动画效果
    //根据 V=s/t 时间相同情况下，距离越长，速度越快
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //固定的时间
    CGFloat duration = 4.0f;
    //整个的宽度
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds);
    
    
    //弹幕开始
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Start);
    }
    //t=s/v
    //速度
    CGFloat speed = wholeWidth/duration;
    //弹幕的长度除以速度
    CGFloat enterDuration = CGRectGetWidth(self.bounds)/speed;
    
    //使用这个是有延迟方法的 这个更好
    [self performSelector:@selector(enterScreen) withObject:nil afterDelay:enterDuration];
    
    
    
    //    //cgd的延时方法  没有办法停止这个是不合适的
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(enterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        if (self.moveStatusBlock) {
    //            self.moveStatusBlock(Enter);
    //        }
    //    });
    
    
    __block CGRect frame = self.frame;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        if (self.moveStatusBlock) {
            self.moveStatusBlock(End);
        }
    }];
}
- (void)enterScreen{
    if (self.moveStatusBlock) {
        self.moveStatusBlock(Enter);
    }
}
//结束动画
- (void)stopAnimation{
    //     停止的方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    //UIView的Animation的动画就是 layer上的动画 所以直接删掉layer的动画即可
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
    
}


@end
