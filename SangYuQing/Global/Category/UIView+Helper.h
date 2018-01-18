//
//  UIView+Helper.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;

@end

@interface UIView (Helper)
- (void)removeAllSubViews;
@end

@interface UIView (Capture)

- (UIImage *)capture;
- (UIImage *)captureWithRect:(CGRect)rect;

@end

@interface UIView (Layer)

- (void)setLayerBorderWidth:(CGFloat)width borderColor:(UIColor *)color;
- (void)setLayerBorderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius;
- (void)setCircleLayerBorderWidth:(CGFloat)width borderColor:(UIColor *)color;
- (void)setLayerDashBorderWidth:(CGFloat)width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius;

@end
