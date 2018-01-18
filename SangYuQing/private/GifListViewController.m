//
//  GifListViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GifListViewController.h"
#import "GiftCollectionViewCell.h"
#import "GiftModel.h"
#import "UserLoginViewController.h"

@interface GifListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong)NSArray *list;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,assign)NSInteger page;
@end

@implementation GifListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.userInteractionEnabled = YES;
    _page = 1;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-50)/4, 140);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionView];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.userInteractionEnabled = YES;
     MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    _collectionView.mj_footer = footer;
    [_collectionView registerNib:[UINib nibWithNibName:@"GiftCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"gift_cell"];
    [self requestList];
}

-(void)footerRereshing{
    _page++;
    [self requestList];
}

-(void)requestList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/jipin/get?pageSize=21&jbtype=1" parameters:@{@"cid":_jc_id,@"page":[NSString stringWithFormat:@"@zd",_page]}  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            _list = [MTLJSONAdapter modelsOfClass:[GiftModel class] fromJSONArray:object[@"data"][@"list"]  error:nil];
            [_collectionView reloadData];
            [_collectionView.mj_footer endRefreshing];
            NSLog(@"-----");
        }else if([object[@"state_code"] isEqualToString:@"8888"]){
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _list.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gift_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    GiftModel *model = _list[indexPath.row];
    [cell configWithModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GiftModel *model = _list[indexPath.row];
    if ([_delegate respondsToSelector:@selector(clickWithModel:)]) {
        [_delegate clickWithModel:model];
    }
}


@end
