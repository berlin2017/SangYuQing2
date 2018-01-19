//
//  BeiJingViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BeiJingViewController.h"
#import "BeiJingModel.h"
#import "BeijingCollectionViewCell.h"

@interface BeiJingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,BeijingCollectionViewCellDelegate>

@property(nonatomic,strong)UICollectionView *collectionview;
@property(nonatomic,strong)NSArray *list;

@end

@implementation BeiJingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-30)/2, ([UIScreen mainScreen].bounds.size.width-10)/8*3);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionview];
    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.top.mas_equalTo(self.view).mas_offset(10);
        make.bottom.mas_equalTo(self.view);
    }];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    _collectionview.backgroundColor = [UIColor clearColor];
    [_collectionview registerNib:[UINib nibWithNibName:@"BeijingCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"beijing_cell"];
    [self requestList];
    
}

-(void)requestList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/background/list" parameters:@{@"type":@"1",@"selectType":@"0",@"sz_id":_sz_id} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
             _list = [MTLJSONAdapter modelsOfClass:[BeiJingModel class] fromJSONArray:object[@"data"][@"backgroundData"] error:nil];
            [_collectionview reloadData];
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
    BeijingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"beijing_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    BeiJingModel *model = _list[indexPath.row];
    cell.delegate = self;
    [cell configWithModel:model index:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BeiJingModel *model = _list[indexPath.row];
  
}

-(void)clickAtIndex:(NSInteger)index{
    BeiJingModel *model = _list[index];
    if (model.goumai==1) {
        //使用
        
        HZHttpClient *client = [HZHttpClient httpClient];
        [client hcPOST:@"/v1/background/use" parameters:@{@"type":@"1",@"selectType":@"0",@"sz_id":_sz_id,@"background_id":model.background_id} success:^(NSURLSessionDataTask *task, id object) {
            if ([object[@"state_code"] isEqualToString:@"0000"]) {
                 [self requestList];;
            }else{
                [self.view makeCenterOffsetToast:object[@"msg"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.view makeCenterOffsetToast:@"请求失败,请重试"];
        }];
    }else if(model.goumai==3){
        
    }else{
        //购买
        HZHttpClient *client = [HZHttpClient httpClient];
        [client hcPOST:@"/v1/background/purchase" parameters:@{@"type":@"1",@"selectType":@"0",@"sz_id":_sz_id,@"background_id":model.background_id} success:^(NSURLSessionDataTask *task, id object) {
            if ([object[@"state_code"] isEqualToString:@"0000"]) {
                [self requestList];
            }else{
                [self.view makeCenterOffsetToast:object[@"msg"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.view makeCenterOffsetToast:@"请求失败,请重试"];
        }];
    }
}

@end
