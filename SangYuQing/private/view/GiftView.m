//
//  GiftView.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GiftView.h"

@interface GiftView()


@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIImageView *deleteImageView;
@property (nonatomic, weak) UIImageView *addImageView;

@end
@implementation GiftView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 注意：该处不要给子控件设置frame与数据，可以在这里初始化子控件的属性
        UIImageView *iconImageView = [[UIImageView alloc] init];
        self.iconImageView = iconImageView;
        [self addSubview: self.iconImageView];
        
        UIImageView *deleteImageView = [[UIImageView alloc] init];
        self.deleteImageView =deleteImageView;
        [self addSubview: self.deleteImageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
        [self.deleteImageView addGestureRecognizer:tap];
        
        UIImageView *addImageView = [[UIImageView alloc] init];
        self.addImageView =addImageView;
        [self addSubview: self.addImageView];
        self.userInteractionEnabled = YES;
        _isEditing = YES;
    }
    return self;
}

-(void)remove{
    [self removeFromSuperview];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconImageViewX = 15;
    CGFloat iconImageViewY = 15;
    CGFloat iconImageViewW = self.frame.size.width-30;
    CGFloat iconImageViewH = self.frame.size.height-30;
    self.iconImageView.frame = CGRectMake(iconImageViewX, iconImageViewY, iconImageViewW, iconImageViewH);
//    self.iconImageView.layer.borderWidth = 1;
//    self.iconImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    self.iconImageView.layer.masksToBounds = YES;

    self.deleteImageView.frame = CGRectMake(0, 0, 30, 30);
    self.deleteImageView.image = [UIImage imageNamed:@"ic_wrong"];
    self.addImageView.frame = CGRectMake(self.frame.size.width-30, self.frame.size.height-30, 30, 30);
    self.addImageView.image = [UIImage imageNamed:@"ic_right"];
}

-(void)setImage:(NSString*)url{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isEditing) {
        UITouch *touch = [touches anyObject];
        CGPoint curP = [touch locationInView:self];
        if([self.deleteImageView.layer containsPoint:curP]){
            [self remove];
        }
        if(curP.x>=self.frame.size.width-30&&curP.y>=self.frame.size.height-30){
            if ([_delegate respondsToSelector:@selector(confirm)]) {
                [_delegate confirm];
            }
        }
    }
}

-(void)finishEdit{
    [self.deleteImageView removeFromSuperview];
    [self.addImageView removeFromSuperview];
    self.iconImageView.layer.borderColor = [UIColor clearColor].CGColor;
    self.iconImageView.layer.borderWidth = 0;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.iconImageView.layer.sublayers = nil;
    _isEditing = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isEditing) {
        // 拿到UITouch就能获取当前点
        UITouch *touch = [touches anyObject];
        // 获取当前点
        CGPoint curP = [touch locationInView:self];
        // 获取上一个点
        CGPoint preP = [touch previousLocationInView:self];
        // 获取手指x轴偏移量
        CGFloat offsetX = curP.x - preP.x;
        // 获取手指y轴偏移量
        CGFloat offsetY = curP.y - preP.y;
        // 移动当前view
        self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);
    }
    
}



@end
