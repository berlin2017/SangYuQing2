//
//  ZhuangShiViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZhuangShiViewController.h"

#import "GifListViewController.h"
#import "GiftLanMuModel.h"

@interface ZhuangShiViewController ()<HZPageVcDataSource, HZPageVcDelegate,GifListViewControllerDelegate>
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *navLabel;
@end

@implementation ZhuangShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    self.view.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.dataSource = self;
}

#pragma mark - HZPageVcDataSource & Delegate
- (NSUInteger)numberOfContentForPageVc:(HZPageViewController *)pageVc
{
    
    return _list.count;
}
- (NSString *)pageVc:(HZPageViewController *)pageVc titleAtIndex:(NSUInteger)index
{
    GiftLanMuModel *model = _list[index];
    return model.jc_name;
}
- (UIViewController *)pageVc:(HZPageViewController *)pageVc viewControllerAtIndex:(NSUInteger)index
{
    GiftLanMuModel *model = _list[index];
    GifListViewController *con = [[GifListViewController alloc]init];
    con.jc_id = model.jc_id;
    con.delegate = self;
    return con;
}

- (void)pageVc:(HZPageViewController *)pageVc didChangeToIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex
{
    
}

-(void)clickWithModel:(GiftModel *)model{
    if ([_delegate2 respondsToSelector:@selector(clickWithModel:)]) {
        [_delegate2 clickWithModel:model];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)back{
    //    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
