//
//  PublicHomeViewController.m
//  SangYuQing
//
//  Created by mac on 2017/12/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PublicHomeViewController.h"
#import "GongMuCollectionViewCell.h"
#import "MDDetailViewController.h"
#import "SearchViewController.h"
#import "HZHttpClient.h"
#import "MuDIModel.h"

@interface PublicHomeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong)UICollectionView *collectionView2;
@property (nonatomic,assign) NSInteger *index;
@end

@implementation PublicHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestList) name:@"follow.notification" object:nil];
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    _index = 0;
    _array = [NSMutableArray new];
    [self requestList];
    
    UICollectionViewFlowLayout *layout2 = [UICollectionViewFlowLayout new];
    layout2.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-3)/3, ([UIScreen mainScreen].bounds.size.width)/3/3*4+45);
    layout2.minimumInteritemSpacing = 0;
    layout2.minimumLineSpacing = 0;
    layout2.headerReferenceSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 250);
    
    _collectionView2 = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout2];
    _collectionView2.delegate = self;
    _collectionView2.dataSource = self;
    _collectionView2.scrollsToTop = NO;
    _collectionView2.showsVerticalScrollIndicator = NO;
    _collectionView2.showsHorizontalScrollIndicator = NO;
    _collectionView2.backgroundColor = [UIColor clearColor];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    _collectionView2.mj_footer = footer;
    _collectionView2.mj_footer.automaticallyChangeAlpha = YES;
    
    _collectionView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _collectionView2.mj_header.automaticallyChangeAlpha = YES;
    
    [_collectionView2 registerNib:[UINib nibWithNibName:@"GongMuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"homeGongmu"];
    [_collectionView2 registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionViewHeader"];
    [self.view addSubview:_collectionView2];
    
    [_collectionView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(-[[UIApplication sharedApplication] statusBarFrame].size.height);
    }];
    
    [self.view addSubview:self.navigationView];
}

-(void)headerRefreshing{
    _index = 0;
    [self requestList];
    [_collectionView2.mj_header endRefreshing];
}

-(void)footerRereshing{
    _index++;
    [self requestList];
    [_collectionView2.mj_footer endRefreshing];
    
}

-(void)requestList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [HZLoadingHUD showHUDInView:self.view];
    [client hcGET:@"/v1/gongmu/list" parameters:@{@"order":@"2",@"page":[NSString stringWithFormat:@"%zd",_index]} success:^(NSURLSessionDataTask *task, id object) {
        
        if(object[@"state"]){
            //             [self.view makeCenterOffsetToast:@"success"];
            NSArray *list = [MTLJSONAdapter modelsOfClass:[MuDIModel class] fromJSONArray:object[@"data"][@"CemeteryData"] error:nil];
            if (_index==0) {
                [_array removeAllObjects];
            }
            [_array addObjectsFromArray:list];
            [_collectionView2 reloadData];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败，请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat minAlphaOffset = 0;//- 64;
    CGFloat maxAlphaOffset = 200;
    CGFloat offset = scrollView.contentOffset.y;
    if(offset==0){
        return;
    }
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    _scaleImageView.alpha = alpha;
}

// 自定义导航栏
-(UIView *)navigationView{
    
    if(_navigationView == nil){
        _navigationView = [[UIView alloc]init];
        _navigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height);
        
        _scaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height)];
        _scaleImageView.image = [UIImage imageNamed:@"bar_bg"];
        _scaleImageView.alpha = 0;
        [_navigationView addSubview:_scaleImageView];
        
        UILabel *title = [[UILabel alloc]init];
        [_navigationView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_navigationView);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
            make.height.mas_equalTo(30);
        }];
        title.font = [UIFont systemFontOfSize:17];
        title.text = @"公共墓园";
        
        UIImageView *back_imageview = [[UIImageView alloc]init];
        [_navigationView addSubview:back_imageview];
        [back_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_navigationView).mas_offset(10);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-19.5);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25);
        }];
        back_imageview.image = [UIImage imageNamed:@"ic_search"];
        back_imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(search)];
        [back_imageview addGestureRecognizer:gesture];
        
    }
    return _navigationView;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _array.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GongMuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeGongmu" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    [cell configWithModel:_array[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MDDetailViewController *controller = [[MDDetailViewController alloc]init];
    MuDIModel *model = _array[indexPath.row];
    controller.sz_id = model.sz_id;
    controller.cemetery_id = model.cemetery_id;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:@"UICollectionViewHeader"
                                                                                   forIndexPath:indexPath];
    
    UIImageView *imageview = [[UIImageView alloc]init];
    [headView addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(headView);
    }];
    imageview.image = [UIImage imageNamed:@"gongmu_home_top"];
    return headView;
}

-(void)search{
    SearchViewController *controller = [[SearchViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
