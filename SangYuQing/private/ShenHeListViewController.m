//
//  ShenHeListViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ShenHeListViewController.h"

#import "SZDetailModel.h"
#import "XiangCeCollectionTableViewCell.h"
#import "PhotoItem.h"
#import "XiangCeCollectionViewCell.h"
#import "ZANImageShowViewController.h"
#import "UserLoginViewController.h"
#import "TJZPCollectionViewCell.h"
#import "MMSheetView.h"
#import "HUPhotoBrowser.h"
#import "UIImageView+HUWebImage.h"

@interface ShenHeListViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,HZImageShowViewControllerDelegate,HZImageShowViewControllerDataSource,XiangCeCollectionViewCellDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong) NSMutableArray *list;
@property(nonatomic,strong)UICollectionView* collectionview;
@property(nonatomic,strong)NSString* choseImageUrl;
@property(nonatomic,strong)UIButton *cancel;
@property(nonatomic,strong)UIButton *del;
@property (nonatomic, strong) NSMutableArray *URLStrings;
@end

@implementation ShenHeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
    _list = [NSMutableArray new];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-20)/3, ([UIScreen mainScreen].bounds.size.width-20)/3+30);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionview];
    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom).mas_offset(10);
        make.bottom.mas_equalTo(self.view);
    }];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    _collectionview.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [_collectionview registerNib:[UINib nibWithNibName:@"XiangCeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"xiangce_cell"];
    [_collectionview registerNib:[UINib nibWithNibName:@"TJZPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"zpsc_cell"];
    [self requestList];
}

-(void)updateUserModel{
    [self requestList];
}

-(void)requestList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/xiangce/verify" parameters:@{@"sz_id":_sz_id,@"type":@"1"}  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            NSArray* list = [MTLJSONAdapter modelsOfClass:[PhotoItem class] fromJSONArray:object[@"data"][@"picData"] error:nil];
            [_list removeAllObjects];
            [_list addObjectsFromArray:list];
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
    return _list.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoItem *model1 = _list[indexPath.row];
    XiangCeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xiangce_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if(![model1.image hasPrefix:@"http:"]){
        model1.image = [NSString stringWithFormat:@"http://www.hwsyq.com/data/images/xiangce/%@",model1.image];
    }
    [cell configWithModel:model1 atIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _URLStrings = [NSMutableArray new];
    for (PhotoItem*item in _list) {
        [_URLStrings addObject:item.image];
    }
    XiangCeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xiangce_cell" forIndexPath:indexPath];
    [HUPhotoBrowser showFromImageView:cell.xiangce_imageview withURLStrings:_URLStrings atIndex:indexPath.row];
}

#pragma mark -
- (NSInteger)numberOfImages:(ZANImageShowViewController *)imageShowViewController
{
    return _list.count;
}

- (NSURL *)imageShowViewController:(ZANImageShowViewController *)imageShowViewController imageURLAtIndex:(NSInteger)index
{
    if (index < _list.count) {
        PhotoItem *model = _list[index];
        return [NSURL URLWithString:model.image];
    }
    return nil;
}

- (NSString *)imageShowViewController:(ZANImageShowViewController *)imageShowViewController imageTextAtIndex:(NSInteger)index
{
    return nil;
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
        title.text = @"待审核照片";
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
        UILabel *right_title = [[UILabel alloc]init];
        [_navigationView addSubview:right_title];
        [right_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_navigationView).mas_offset(-10);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
            make.height.mas_equalTo(30);
        }];
        right_title.font = [UIFont systemFontOfSize:14];
        right_title.text = @"编辑";
        right_title.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(edit)];
        [right_title addGestureRecognizer:tap];
        
        
    }
    return _navigationView;
}

-(void)edit{
    _cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancel.backgroundColor = [UIColor clearColor];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:_cancel];
    _cancel.tintColor = [UIColor blackColor];
    _cancel.layer.borderWidth = 1;
    _cancel.layer.borderColor = [UIColor blackColor].CGColor;
    _cancel.layer.cornerRadius = 5;
    _cancel.layer.masksToBounds = YES;
    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-15);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-30)/2);
    }];
    [_cancel addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
    
    _del = [UIButton buttonWithType:UIButtonTypeSystem];
    _del.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
    [_del setTitle:@"审核通过" forState:UIControlStateNormal];
    _del.tintColor = [UIColor whiteColor];
    _del.layer.borderWidth = 1;
    _del.layer.borderColor = [UIColor colorWithHexString:@"CD853F"].CGColor;
    _del.layer.cornerRadius = 5;
    _del.layer.masksToBounds = YES;
    [self.view addSubview:_del];
    [_del mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-30)/2);
    }];
    [_del addTarget:self action:@selector(delModel) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *array = [NSMutableArray new];
    for (PhotoItem*item in _list) {
        item.canEdit = YES;
        [array addObject:item];
    }
    [_list removeAllObjects];
    [_list addObjectsFromArray:array];
    [_collectionview reloadData];
}

-(void)delModel{
    NSString *s= @"";
    for (PhotoItem*item in _list) {
        if (item.isSelected) {
            s= [s stringByAppendingString: item.szxcp_id];
            s= [s stringByAppendingString: @","];
        }
    }
    if ([NSString isEmptyString:s]) {
        [self.view makeCenterOffsetToast:@"请选择要审核的照片"];
    }else{
        HZHttpClient *client = [HZHttpClient httpClient];
        [client hcPOST:@"/v1/xiangce/allow" parameters:@{@"id":s}  success:^(NSURLSessionDataTask *task, id object) {
            if ([object[@"state_code"] isEqualToString:@"0000"]) {
                [self requestList];
                [self cancelEdit];
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
}

-(void)cancelEdit{
    [_cancel removeFromSuperview];
    [_del removeFromSuperview];
    NSMutableArray *array = [NSMutableArray new];
    for (PhotoItem*item in _list) {
        item.canEdit = NO;
        [array addObject:item];
    }
    [_list removeAllObjects];
    [_list addObjectsFromArray:array];
    [_collectionview reloadData];
}

-(void)setSelectedAtIndex:(NSInteger)index{
    
    NSMutableArray *array = [NSMutableArray new];
    for (PhotoItem*item in _list) {
        if ([_list indexOfObject:item]==index) {
            item.isSelected = !item.isSelected;
        }
        [array addObject:item];
    }
    [_list removeAllObjects];
    [_list addObjectsFromArray:array];
    [_collectionview reloadData];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
