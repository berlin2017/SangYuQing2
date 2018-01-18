//
//  HZLoadingHUD.m
//  HZLoadingHUD
//
//  Created by History on 15/1/22.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import "HZLoadingHUD.h"

const CGFloat kCircleViewRadius = 25.f;

static NSString *kMMRingStrokeAnimationKey = @"mmmaterialdesignspinner.stroke";
static NSString *kMMRingRotationAnimationKey = @"mmmaterialdesignspinner.rotation";

@interface HZCircleProgressView : UIView
@property (assign, nonatomic) CGFloat progress;
@property (strong, nonatomic) UIColor *progressTintColor;
@property (strong, nonatomic) UIColor *backgroundTintColor;
@end

@implementation HZCircleProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerKVO];
        self.backgroundColor = [UIColor clearColor];
        self.progress = 0.f;
        _progressTintColor = [[UIColor alloc] initWithWhite:1.f alpha:1.f];
        _backgroundTintColor = [[UIColor alloc] initWithWhite:1.f alpha:.1f];
    }
    return self;
}

- (void)dealloc
{
    [self removeKVO];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat lineWidth = 2.f;
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapButt;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [_backgroundTintColor set];
    [processBackgroundPath stroke];
    // Draw progress
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapSquare;
    processPath.lineWidth = lineWidth;
    endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [_progressTintColor set];
    [processPath stroke];
}

- (void)registerKVO
{
    [self addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeKVO
{
    [self removeObserver:self forKeyPath:@"progress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"progress"]) {
        [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
    }
}

@end

@interface HZCircleView : UIView
@property (strong, nonatomic) CAShapeLayer *progressLayer;
@property (assign, nonatomic) BOOL isAnimating;
@property (assign, nonatomic) CGFloat lineWidth;
@property (assign, nonatomic) BOOL hidesWhenStopped;
@property (strong, nonatomic) CAMediaTimingFunction *timingFunction;
@end

@implementation HZCircleView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.layer addSublayer:self.progressLayer];
    
    // See comment in resetAnimations on why this notification is used.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAnimations) name:UIApplicationDidBecomeActiveNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    [self updatePath];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    self.progressLayer.strokeColor = self.tintColor.CGColor;
}
- (void)resetAnimations {
    // If the app goes to the background, returning it to the foreground causes the animation to stop (even though it's not explicitly stopped by our code). Resetting the animation seems to kick it back into gear.
    if (self.isAnimating) {
        [self stopAnimating];
        [self startAnimating];
    }
}

- (void)startAnimating {
    if (self.isAnimating)
        return;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 4.f;
    animation.fromValue = @(0.f);
    animation.toValue = @(2 * M_PI);
    animation.repeatCount = INFINITY;
    [self.progressLayer addAnimation:animation forKey:kMMRingRotationAnimationKey];
    
    CABasicAnimation *headAnimation = [CABasicAnimation animation];
    headAnimation.keyPath = @"strokeStart";
    headAnimation.duration = 1.f;
    headAnimation.fromValue = @(0.f);
    headAnimation.toValue = @(0.25f);
    headAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animation];
    tailAnimation.keyPath = @"strokeEnd";
    tailAnimation.duration = 1.f;
    tailAnimation.fromValue = @(0.f);
    tailAnimation.toValue = @(1.f);
    tailAnimation.timingFunction = self.timingFunction;
    
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animation];
    endHeadAnimation.keyPath = @"strokeStart";
    endHeadAnimation.beginTime = 1.f;
    endHeadAnimation.duration = 0.5f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.f);
    endHeadAnimation.timingFunction = self.timingFunction;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animation];
    endTailAnimation.keyPath = @"strokeEnd";
    endTailAnimation.beginTime = 1.f;
    endTailAnimation.duration = 0.5f;
    endTailAnimation.fromValue = @(1.f);
    endTailAnimation.toValue = @(1.f);
    endTailAnimation.timingFunction = self.timingFunction;
    
    CAAnimationGroup *animations = [CAAnimationGroup animation];
    [animations setDuration:1.5f];
    [animations setAnimations:@[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation]];
    animations.repeatCount = INFINITY;
    [self.progressLayer addAnimation:animations forKey:kMMRingStrokeAnimationKey];
    
    
    self.isAnimating = true;
    
    if (self.hidesWhenStopped) {
        self.hidden = NO;
    }
}

- (void)stopAnimating {
    if (!self.isAnimating)
        return;
    
    [self.progressLayer removeAnimationForKey:kMMRingRotationAnimationKey];
    [self.progressLayer removeAnimationForKey:kMMRingStrokeAnimationKey];
    self.isAnimating = false;
    
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}

#pragma mark - Private

- (void)updatePath {
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2) - self.progressLayer.lineWidth / 2;
    CGFloat startAngle = (CGFloat)(0);
    CGFloat endAngle = (CGFloat)(2*M_PI);
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.progressLayer.path = path.CGPath;
    
    self.progressLayer.strokeStart = 0.f;
    self.progressLayer.strokeEnd = 0.f;
}

#pragma mark - Properties

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = self.tintColor.CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineWidth = 1.5f;
    }
    return _progressLayer;
}

- (BOOL)isAnimating {
    return _isAnimating;
}

- (CGFloat)lineWidth {
    return self.progressLayer.lineWidth;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.progressLayer.lineWidth = lineWidth;
    [self updatePath];
}

- (void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _hidesWhenStopped = hidesWhenStopped;
    self.hidden = !self.isAnimating && hidesWhenStopped;
}
@end

@interface HZLoadingHUD ()
{
    UILabel *_titleLabel;
    UIView *_loadingBgView;
    UIView *_loadingView;
}
@property (copy, nonatomic) NSString *title;
@end

@implementation HZLoadingHUD


+ (instancetype)showHUDInView:(UIView *)view
{
    HZLoadingHUD *hud = [[HZLoadingHUD alloc] initWithFrame:CGRectZero];
    hud.mode = HZLoadingHUDModeDefalut;
    [view addSubview:hud];
    [hud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    return hud;
}
+ (instancetype)showUserInteractionDisabledHUDInView:(UIView *)view
{
    HZLoadingHUD *hud = [[HZLoadingHUD alloc] initWithFrame:CGRectZero];
    hud.userInteractionEnabled = NO;
    hud.mode = HZLoadingHUDModeDefalut;
    [view addSubview:hud];
    [hud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
    return hud;
}
+ (void)hideHUDInView:(UIView *)view
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:HZLoadingHUD.class]) {
            [subView removeFromSuperview];
        }
    }
}
+ (void)hideHUDInView:(UIView *)view showMessage:(NSString *)message
{
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:HZLoadingHUD.class]) {
            [subView removeFromSuperview];
        }
    }
    [view makeCenterOffsetToast:message];
}
+ (instancetype)showHUDInView:(UIView *)view title:(NSString *)title
{
    return nil;
}

+ (instancetype)HUDForView:(UIView *)view
{
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (HZLoadingHUD *)subview;
        }
    }
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        [self defaultInit];
    }
    return self;
}

- (void)defaultInit
{
    CGSize kLoadViewSize = CGSizeMake(100, 75);
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.alpha = 0.3f;
    bgView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.f];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    _loadingBgView = [[UIView alloc] init];
    _loadingBgView.translatesAutoresizingMaskIntoConstraints = NO;
    _loadingBgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.f];
    _loadingBgView.layer.cornerRadius = 5.f;
    
    [self addSubview:_loadingBgView];
    [_loadingBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(kLoadViewSize);
    }];

    if (_title.length) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.text = _title;
        
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self);
            make.right.mas_equalTo(self);
            make.top.mas_equalTo(_loadingBgView.mas_bottom);
        }];
    }
    
    [self registerKVO];
    
}

- (void)dealloc
{
    [self removeKVO];
}

- (void)updateLoadingView
{
    [_loadingView removeFromSuperview];
    switch (_mode) {
        case HZLoadingHUDModeProgress: {
            _loadingView = [[HZCircleProgressView alloc] init];
            _loadingView.tintColor = [UIColor whiteColor];
            _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
            [(HZCircleProgressView *)_loadingView setProgress:0.f];
            [_loadingBgView addSubview:_loadingView];
            [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_loadingBgView);
                make.size.mas_equalTo(CGSizeMake(2 * kCircleViewRadius, 2 * kCircleViewRadius));
            }];
        }
            break;
        case HZLoadingHUDModeDefalut: {
            _loadingView = [[HZCircleView alloc] init];
            _loadingView.tintColor = [UIColor whiteColor];
            _loadingView.translatesAutoresizingMaskIntoConstraints = NO;
            [_loadingBgView addSubview:_loadingView];
            [(HZCircleView *)_loadingView startAnimating];
            [_loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_loadingBgView);
                make.size.mas_equalTo(CGSizeMake(2 * kCircleViewRadius, 2 * kCircleViewRadius));
            }];
            [self setNeedsLayout];
        }
            break;
        default:
            break;
    }
}

- (void)updateProgress
{
    
}

- (void)registerKVO
{
    [self addObserver:self forKeyPath:@"mode" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeKVO
{
    [self removeObserver:self forKeyPath:@"mode"];
    [self removeObserver:self forKeyPath:@"progress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"mode"]) {
        [self updateLoadingView];
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
    else if ([keyPath isEqualToString:@"progress"]) {
        if ([_loadingView respondsToSelector:@selector(setProgress:)]) {
            [(id)_loadingView setValue:@(_progress) forKey:@"progress"];
        }
    }
    else {
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
