//
//  XiangCeGuanLIViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "XiangCeGuanLIViewController.h"
#import "MuDiDetailModel.h"
#import "UserLoginViewController.h"
#import "PhotoModel.h"
#import "XiangCeCollectionViewCell.h"
#import "XiangCeListViewController.h"
#import "CJXCCollectionViewCell.h"

@interface XiangCeGuanLIViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong) UICollectionView *collectionview;
@property (nonatomic,strong) MuDiDetailModel *detail;
@end

@implementation XiangCeGuanLIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
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
    [_collectionview registerNib:[UINib nibWithNibName:@"CJXCCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"xc_add_cell"];
    [self requestList];
}

-(void)requestList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/gongmu/albums" parameters:@{@"id":_sz_id}  success:^(NSURLSessionDataTask *task, id object) {
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
    return _detail.albums.count+1;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row== _detail.albums.count) {
        CJXCCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xc_add_cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    
    PhotoModel *model = _detail.albums[indexPath.row];
    XiangCeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xiangce_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell configWithXiangCeModel:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row== _detail.albums.count) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加相册" message:@"请输入相册名称" preferredStyle:UIAlertControllerStyleAlert];
        //以下方法就可以实现在提示框中输入文本；
        
        //在AlertView中添加一个输入框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            
            textField.placeholder = @"请输入相册名称";
        }];
        
        //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
            
            //输出 检查是否正确无误
            NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
            if ([NSString isEmptyString:envirnmentNameTextField.text]) {
                [self.view makeCenterOffsetToast:@"名称不能为空"];
                return ;
            }
            [self add:envirnmentNameTextField.text];
            
        }]];
        
        //添加一个取消按钮
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
        //present出AlertView
        [self presentViewController:alertController animated:true completion:nil];
        return ;
    }
    XiangCeListViewController *controller = [[XiangCeListViewController alloc]init];
    controller.sz_id = _sz_id;
    PhotoModel *model = _detail.albums[indexPath.row];
    controller.xcid = model.szxc_id;
    controller.type = 1;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)add:(NSString *)name{
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/xiangce/add" parameters:@{@"sz_id":_sz_id,@"type":@"1",@"name":name,@"image":@"2017091203141322.jpg"}  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
           [self requestList];
        }else if([object[@"state_code"] isEqualToString:@"8888"]){
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
        [HZLoadingHUD hideHUDInView:self.view];
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
        title.text = @"相册管理";
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
