//
//  JiPinManageViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JiPinManageViewController.h"
#import "JPXModel.h"
#import "UserLoginViewController.h"
#import "JPGLCollectionViewCell.h"

@interface JiPinManageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,JPGLCollectionViewCellDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong) NSArray *list;
@property(nonatomic,strong)UICollectionView* collectionview;
@end

@implementation JiPinManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/2, 120);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionview];
    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.top.mas_equalTo(self.navigationView.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(self.view);
    }];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    _collectionview.backgroundColor = [UIColor clearColor];
    [_collectionview registerNib:[UINib nibWithNibName:@"JPGLCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"detail_guanli_cell"];
    [self requestGift];
}

-(void)requestGift{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/jipinxiang/get-jipins" parameters:@{@"sz_id":_sz_id,@"jpx_type":@"1"} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            _list = [MTLJSONAdapter modelsOfClass:[JPXModel class] fromJSONArray:object[@"data"][@"list"] error:nil];
            [_collectionview reloadData];
            NSLog(@"-----");
        }else if([object[@"state_code"] isEqualToString:@"9999"]){
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"获取礼物失败,请重试"];
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
    JPXModel *model1 = _list[indexPath.row];
    JPGLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detail_guanli_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    [cell configWithModel:model1];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(void)changed:(JPXModel*)model show:(BOOL)show{
    NSString *type;
    if(show){
        type = @"1";
    }else{
        type = @"0";
    }
    [HZLoadingHUD showHUDInView:self.view];
   HZHttpClient *client =  [HZHttpClient httpClient];
    [client hcPOST:@"/v1/jipinxiang/operate-jipin" parameters:@{@"szjpxid":[NSString stringWithFormat:@"%zd",model.szjpx_id],@"optype":type} success:^(NSURLSessionDataTask *task, id object) {
        [HZLoadingHUD hideHUDInView:self.view];
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"gift.manager" object:nil];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
         [HZLoadingHUD hideHUDInView:self.view];
    }];
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
        title.text = @"祭品管理";
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
