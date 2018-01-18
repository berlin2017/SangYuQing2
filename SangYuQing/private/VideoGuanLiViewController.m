//
//  VideoGuanLiViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "VideoGuanLiViewController.h"
#import "MuDiDetailModel.h"
#import "UserLoginViewController.h"
#import "VideoModel.h"
#import "DetailVideoCollectionViewCell.h"
#import "VideoPlayViewController.h"

@interface VideoGuanLiViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong) MuDiDetailModel *detail;
@property(nonatomic,strong)UICollectionView* collectionview ;
@end

@implementation VideoGuanLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-10)/2, ([UIScreen mainScreen].bounds.size.width-10)/8*3+25);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionview];
    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom).mas_offset(20);
        make.bottom.mas_equalTo(self.view);
    }];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    _collectionview.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [_collectionview registerNib:[UINib nibWithNibName:@"DetailVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"video_cell"];
    [self requestList];
}

-(void)requestList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/gongmu/videos" parameters:@{@"id":_sz_id}  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            _detail = [MTLJSONAdapter modelOfClass:[MuDiDetailModel class] fromJSONDictionary:object[@"data"][@"CemeteryInfo"] error:nil];
            [_collectionview reloadData];
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
    return _detail.videos.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoModel *model1 = _detail.videos[indexPath.row];
    DetailVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"video_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell configWithModel:model1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoModel *model1 = _detail.videos[indexPath.row];
    VideoPlayViewController *controller = [[VideoPlayViewController alloc]init];
    controller.video_url = model1.video;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

// 自定义导航栏
-(UIView *)navigationView{
    
    if(_navigationView == nil){
        _navigationView = [[UIView alloc]init];
        _navigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height);
        
        _scaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height)];
        _scaleImageView.image = [UIImage imageNamed:@"bar_bg"];
        _scaleImageView.alpha = 1;
        [_navigationView addSubview:_scaleImageView];
        
        UILabel *title = [[UILabel alloc]init];
        [_navigationView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_navigationView);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
            make.height.mas_equalTo(30);
        }];
        title.font = [UIFont systemFontOfSize:17];
        title.text = @"视频管理";
        UIImageView *back_imageview = [[UIImageView alloc]init];
        [_navigationView addSubview:back_imageview];
        [back_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_navigationView).mas_offset(10);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-19.5);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25);
        }];
        back_imageview.image = [UIImage imageNamed:@"ic_back"];
        back_imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
        [back_imageview addGestureRecognizer:gesture];
    }
    return _navigationView;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
