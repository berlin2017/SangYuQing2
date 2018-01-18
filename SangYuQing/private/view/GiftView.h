//
//  GiftView.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftViewDelegate <NSObject>

@optional
-(void)confirm;
@end

@interface GiftView : UIView

-(void)setImage:(NSString*)url;
@property(nonatomic,weak)id<GiftViewDelegate>delegate;
@property(nonatomic,assign)BOOL isEditing;
-(void)finishEdit;
@end
