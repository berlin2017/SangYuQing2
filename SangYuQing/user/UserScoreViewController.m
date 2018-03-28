////
////  UserScoreViewController.m
////  SangYuQing
////
////  Created by mac on 2018/1/8.
////  Copyright © 2018年 mac. All rights reserved.
////
//
//#import "UserScoreViewController.h"
//#import "UserScoreCollectionViewCell.h"
//#import "UIColor+Helper.h"
//#import "UIView+ToastHelper.h"
//#import "UserScorePayCollectionViewCell.h"
//#import "UserScoreDetailViewController.h"
//#import "UserModel.h"
//#import "UserManager.h"
//#import "UserLoginViewController.h"
//#import "OrderInfo.h"
//#import "OtherMoneyCollectionViewCell.h"
//#import "JiFenModel.h"
//#import "HZWebBaseViewController.h"
//
//@interface UserScoreViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
//@property(nonatomic,strong) UIView *navigationView;       // 导航栏
//@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
//@property(nonatomic,copy)NSIndexPath *lastIndexPath;
//@property(nonatomic,copy)NSIndexPath *lastPayIndexPath;
//@property(nonatomic,copy)UILabel *score;
//@property (nonatomic,strong)OrderInfo *order;
//@property (nonatomic,strong)UICollectionView *collectionview;
//@property (nonatomic,strong)UICollectionView *collectionview2;
//@property (nonatomic,copy)NSMutableArray *list;
//@end
//
//@implementation UserScoreViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.navigationController.navigationBarHidden = YES;
//    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
//    [self.view setBackgroundColor:bgColor];
//    [self.view addSubview:self.navigationView];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payWXSuccess) name:@"wx.pay.success" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAliSuccess:) name:@"ali.pay.success" object:nil];
//    self.view.userInteractionEnabled = YES;
//    UITapGestureRecognizer *key_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKey)];
//    //    [self.view addGestureRecognizer:key_recognizer];
//    _list = [NSMutableArray new];
//    JiFenModel *model = [[JiFenModel alloc]init];
//    model.jifen = 100;
//    model.money = 10;
//    [_list addObject:model];
//
//    JiFenModel *model2 = [[JiFenModel alloc]init];
//    model2.jifen = 500;
//    model2.money = 50;
//    [_list addObject:model2];
//    JiFenModel *model3 = [[JiFenModel alloc]init];
//    model3.jifen = 1000;
//    model3.money = 100;
//    [_list addObject:model3];
//    JiFenModel *model4 = [[JiFenModel alloc]init];
//    model4.jifen = 2000;
//    model4.money = 200;
//    [_list addObject:model4];
//    JiFenModel *model5 = [[JiFenModel alloc]init];
//    model5.jifen = 3000;
//    model5.money = 300;
//    [_list addObject:model5];
//    JiFenModel *model6 = [[JiFenModel alloc]init];
//    [_list addObject:model6];
//
//    _lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    _lastPayIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//
//    UIScrollView * scrollview = [[UIScrollView alloc]init];
//    [self.view addSubview:scrollview];
//    scrollview.userInteractionEnabled = YES;
//    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view);
//        make.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view);
//        make.top.mas_equalTo(self.navigationView.mas_bottom);
//    }];
//
//    UIView *contentview = [[UIView alloc]init];
//    [scrollview addSubview:contentview];
//    contentview.userInteractionEnabled = YES;
//
//    UIView *topview = [[UIView alloc]init];
//    [contentview addSubview:topview];
//    topview.userInteractionEnabled = YES;
//    [topview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view).mas_offset(10);
//        make.right.mas_equalTo(self.view).mas_offset(-10);
//        make.top.mas_equalTo(self.navigationView.mas_bottom).mas_offset(10);
//        make.width.mas_equalTo(100);
//    }];
//    UIImageView *bg = [[UIImageView alloc]init];
//    [topview addSubview:bg];
//    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(topview);
//    }];
//    bg.image = [UIImage imageNamed:@"user_jifen_bg"];
//
//
//    _score = [[UILabel alloc]init];
//    [topview addSubview:_score];
//    [_score mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.mas_equalTo(topview);
//    }];
//    if ([UserManager ahnUser]) {
//        UserModel *user = [UserManager ahnUser];
//        _score.text = [NSString stringWithFormat:@"%zd",user.bonus_point];
//    }else{
//        _score.text = @"0";
//    }
//
//    _score.font = [UIFont systemFontOfSize:19];
//
//
//
//    UILabel *name = [[UILabel alloc]init];
//    [topview addSubview:name];
//    [name mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(topview);
//        make.right.mas_equalTo(_score.mas_left).mas_offset(-40);
//    }];
//    name.text = @"当前积分:";
//    name.font = [UIFont systemFontOfSize:15];
//
//    UILabel *jifen = [[UILabel alloc]init];
//    [topview addSubview:jifen];
//    [jifen mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(topview);
//        make.left.mas_equalTo(_score.mas_right).mas_offset(40);
//    }];
//    jifen.text = @"积分";
//    jifen.font = [UIFont systemFontOfSize:15];
//
//
//
//    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-60)/3 , 60);
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
//    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
//    _collectionview.delegate = self;
//    _collectionview.dataSource = self;
//    _collectionview.tag = 1000;
//    _collectionview.userInteractionEnabled = YES;
//    [_collectionview registerNib:[UINib nibWithNibName:@"UserScoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"score_jifen_cell"];
//    [_collectionview registerNib:[UINib nibWithNibName:@"OtherMoneyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"other_cell"];
//    [contentview addSubview:_collectionview];
//
//    _collectionview.backgroundColor = [UIColor clearColor];
//    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view).mas_offset(10);
//        make.right.mas_equalTo(self.view).mas_offset(-10);
//        make.top.mas_equalTo(topview.mas_bottom).mas_offset(20);
//        make.height.mas_equalTo(60*2+20);
//    }];
//
//    [_collectionview selectItemAtIndexPath:_lastIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//
//    UICollectionViewFlowLayout *layout2 = [UICollectionViewFlowLayout new];
//    layout2.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-60)/2 , 50);
//    layout2.minimumLineSpacing = 10;
//    layout2.minimumInteritemSpacing = 10;
//    _collectionview2 = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout2];
//    _collectionview2.delegate = self;
//    _collectionview2.dataSource = self;
//    _collectionview2.tag = 2000;
//    _collectionview2.userInteractionEnabled = YES;
//    [_collectionview2 registerNib:[UINib nibWithNibName:@"UserScorePayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"score_pay_cell"];
//    [contentview addSubview:_collectionview2];
//    _collectionview2.backgroundColor = [UIColor clearColor];
//    [_collectionview2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.view).mas_offset(10);
//        make.right.mas_equalTo(self.view).mas_offset(-10);
//        make.top.mas_equalTo(_collectionview.mas_bottom).mas_offset(20);
//        make.height.mas_equalTo(60);
//    }];
//
//    [_collectionview2 selectItemAtIndexPath:_lastPayIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
//
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [contentview addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*0.6);
//        make.centerX.mas_equalTo(self.view);
//        make.top.mas_equalTo(_collectionview2.mas_bottom).mas_offset(20);
//        make.height.mas_equalTo(40);
//    }];
//    btn.userInteractionEnabled = YES;
//    [btn setTitle:@"确认支付" forState: UIControlStateNormal];
//    btn.tintColor = [UIColor whiteColor];
//    btn.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 5;
//    [btn addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
//
//    UILabel *bottom_name = [[UILabel alloc]init];
//    [contentview addSubview:bottom_name];
//    [bottom_name mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(btn.mas_bottom).mas_offset(40);
//        make.left.mas_equalTo(self.view).mas_equalTo(10);
//        make.right.mas_equalTo(self.view).mas_equalTo(-10);
//    }];
//    bottom_name.text = @"支付说明";
//    bottom_name.userInteractionEnabled = YES;
//    bottom_name.font = [UIFont systemFontOfSize:19];
//
//    UILabel *bottom_detail = [[UILabel alloc]init];
//    [contentview addSubview:bottom_detail];
//    [bottom_detail mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(bottom_name.mas_bottom).mas_offset(20);
//        make.left.mas_equalTo(self.view).mas_equalTo(10);
//        make.right.mas_equalTo(self.view).mas_equalTo(-10);
//    }];
//    bottom_detail.numberOfLines = 0;
//    bottom_detail.text = @"您可在此将拥有的积分进行充值，以满足在不同场合的消费需求。";
//    bottom_detail.font = [UIFont systemFontOfSize:15];
//
//    UILabel *bottom_name2 = [[UILabel alloc]init];
//    [contentview addSubview:bottom_name2];
//    [bottom_name2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(bottom_detail.mas_bottom).mas_offset(20);
//        make.left.mas_equalTo(self.view).mas_equalTo(10);
//        make.right.mas_equalTo(self.view).mas_equalTo(-10);
//    }];
//    bottom_name2.text = @"兑换说明";
//    bottom_name2.font = [UIFont systemFontOfSize:19];
//
//    UILabel *bottom_detail2 = [[UILabel alloc]init];
//    [contentview addSubview:bottom_detail2];
//    [bottom_detail2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(bottom_name2.mas_bottom).mas_offset(20);
//        make.left.mas_equalTo(self.view).mas_equalTo(10);
//        make.right.mas_equalTo(self.view).mas_equalTo(-10);
//    }];
//    bottom_detail2.numberOfLines = 0;
//    bottom_detail2.text = @"1元=10积分";
//    bottom_detail2.font = [UIFont systemFontOfSize:15];
//
//    [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view);
//        make.left.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(bottom_detail2.mas_bottom);
//        make.right.mas_equalTo(self.view);
//    }];
//
//    [self getJiFen];
//}
//
//-(void)getJiFen{
//    [HZLoadingHUD showHUDInView:self.view];
//    HZHttpClient *client = [HZHttpClient httpClient];
//    [client hcPOST:@"/v1/ucenter/my-jifen" parameters:nil success:^(NSURLSessionDataTask *task, id object) {
//        if ([object[@"state_code"] isEqualToString:@"0000"]) {
//            long jifen = [object[@"data"][@"jifen"] longValue];
//            UserModel *user = [UserManager ahnUser];
//            user.bonus_point = jifen;
//            [UserManager saveAhnUser:user];
//            _score.text = [NSString stringWithFormat:@"%zd",jifen];
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"user.jifen.change" object:nil];
//        }else  if ([object[@"state_code"] isEqualToString:@"9999"]){
//            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
//            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
//            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
//            [viewController setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:viewController animated:YES];
//        }else{
//            [self.view makeCenterOffsetToast:object[@"msg"]];
//        }
//        [HZLoadingHUD hideHUDInView:self.view];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
//        [HZLoadingHUD hideHUDInView:self.view];
//    }];
//}
//
//-(void)updateUserModel{
//    [self getJiFen];
//}
//
//-(void)payWXSuccess{
//    [HZLoadingHUD showHUDInView:self.view];
//    HZHttpClient *client = [HZHttpClient httpClient];
//    [client hcPOST:@"/v1/payment/weixinnotify" parameters:@{@"transaction_id":_order.trade_no,@"trade_no":_order.prepay_id,@"out_trade_no":_order.trade_no} success:^(NSURLSessionDataTask *task, id object) {
//        if ([object[@"state_code"] isEqualToString:@"0000"]) {
//            //刷新用户积分
//            [self.view makeCenterOffsetToast:@"充值成功"];
//            [self getJiFen];
//
//        }else  if ([object[@"state_code"] isEqualToString:@"9999"]){
//            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
//            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
//            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
//            [viewController setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:viewController animated:YES];
//        }else{
//            [self.view makeCenterOffsetToast:object[@"msg"]];
//        }
//
//        [HZLoadingHUD hideHUDInView:self.view];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
//        [HZLoadingHUD hideHUDInView:self.view];
//    }];
//
//
//}
//
//-(void)payAliSuccess:(NSNotification *)notification{
//    [HZLoadingHUD showHUDInView:self.view];
//    HZHttpClient *client = [HZHttpClient httpClient];
//    [client hcPOST:@"/v1/payment/alipaynotify" parameters:@{@"transaction_id":_order.trade_no,@"trade_no":notification.object,@"out_trade_no":_order.trade_no} success:^(NSURLSessionDataTask *task, id object) {
//        if ([object[@"state_code"] isEqualToString:@"0000"]) {
//            //刷新用户积分
//            [self.view makeCenterOffsetToast:@"充值成功"];
//            [self getJiFen];
//
//        }else  if ([object[@"state_code"] isEqualToString:@"9999"]){
//            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
//            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
//            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
//            [viewController setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:viewController animated:YES];
//        }else{
//            [self.view makeCenterOffsetToast:object[@"msg"]];
//        }
//
//        [HZLoadingHUD hideHUDInView:self.view];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
//        [HZLoadingHUD hideHUDInView:self.view];
//    }];
//}
//
//#pragma mark ---- UICollectionViewDataSource
//
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    if (collectionView.tag == 1000) {
//        return _list.count;
//    }
//    return 2;
//
//}
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (collectionView.tag == 1000) {
//        JiFenModel *model = _list[indexPath.row];
//        if (indexPath.row==5&&!model.money) {
//            OtherMoneyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"other_cell" forIndexPath:indexPath];
//            cell.edit.backgroundColor = [UIColor clearColor];
//            cell.edit.text = @"其他";
//            cell.edit.delegate = self;
//            return cell;
//        }
//        UserScoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"score_jifen_cell" forIndexPath:indexPath];
//        if(indexPath==_lastIndexPath){
//            [cell setBackColor:[UIColor colorWithHexString:@"CD853F"]];
//        }else{
//              [cell setBackColor:[UIColor clearColor]];
//        }
//        [cell configWithModel:_list[indexPath.row]];
//        return cell;
//    }else{
//        UserScorePayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"score_pay_cell" forIndexPath:indexPath];
//        cell.backgroundColor = [UIColor whiteColor];
//        [cell configWithIndex:indexPath.row];
//        if (indexPath==_lastPayIndexPath) {
//            [cell setBoraderColor:[UIColor colorWithHexString:@"CD853F"]];
//        }
//        return cell;
//    }
//
//
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    NSLog(@"cell #%d was selected", indexPath.row);
//    if (collectionView.tag == 1000) {
//        if (indexPath.row!=5) {
//            [_list removeObjectAtIndex:5];
//            JiFenModel *model = [[JiFenModel alloc]init];
//            [_list addObject:model];
//            [collectionView reloadData];
//        }
//    }
//    return;
//}
//
////当cell高亮时返回是否高亮
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
//
//{
//    if (collectionView.tag == 1000) {
//        if (indexPath!=_lastIndexPath) {
//            UserScoreCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath ];
//            [cell setBackColor:[UIColor colorWithHexString:@"CD853F"]];
//            UserScoreCollectionViewCell *cell2 = [collectionView cellForItemAtIndexPath:_lastIndexPath ];
//            [cell2 setBackColor:[UIColor clearColor]];
//            _lastIndexPath = indexPath;
//        }
//    }else if(collectionView.tag == 2000){
//        if (indexPath!=_lastPayIndexPath) {
//            UserScorePayCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath ];
//            [cell setBoraderColor:[UIColor colorWithHexString:@"CD853F"]];
//            UserScorePayCollectionViewCell *cell2 = [collectionView cellForItemAtIndexPath:_lastPayIndexPath ];
//            [cell2 setBoraderColor:[UIColor clearColor]];
//            _lastPayIndexPath = indexPath;
//        }
//    }
//}
//
//- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (collectionView.tag == 1000) {
//        UserScoreCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//        [cell setBackColor:[UIColor colorWithHexString:@"CD853F"]];
//    }else if(collectionView.tag == 2000){
//        if (indexPath!=_lastPayIndexPath) {
//            UserScorePayCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath ];
//            [cell setBoraderColor:[UIColor clearColor]];
//        }
//    }
//
//}
//
//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    textField.text = @"";
//    textField.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
//    UserScoreCollectionViewCell *cell2 = [_collectionview cellForItemAtIndexPath:_lastIndexPath];
//    [cell2 setBackColor:[UIColor clearColor]];
//    _lastIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
//}
//
//-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
//    JiFenModel *model =  _list[5];
//    model.jifen = [textField.text integerValue]*10;
//    model.money = [textField.text integerValue];
//    [_collectionview reloadData];
//}
//
//
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//
//    [self.view endEditing:YES];
//
//    return YES;
//}
//
//
//// 自定义导航栏
//-(UIView *)navigationView{
//
//    if(_navigationView == nil){
//        _navigationView = [[UIView alloc]init];
//        _navigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height);
//
//        _scaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height)];
//        _scaleImageView.image = [UIImage imageNamed:@"bar_bg"];
//        _scaleImageView.alpha = 1;
//        [_navigationView addSubview:_scaleImageView];
//
//        UILabel *title = [[UILabel alloc]init];
//        [_navigationView addSubview:title];
//        [title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(_navigationView);
//            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
//            make.height.mas_equalTo(30);
//        }];
//        title.font = [UIFont systemFontOfSize:17];
//        title.text = @"我的积分";
//        UIImageView *back_imageview = [[UIImageView alloc]init];
//        [_navigationView addSubview:back_imageview];
//        [back_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_navigationView).mas_offset(10);
//            make.bottom.mas_equalTo(_navigationView).mas_offset(-19.5);
//            make.height.mas_equalTo(25);
//            make.width.mas_equalTo(25);
//        }];
//        back_imageview.image = [UIImage imageNamed:@"ic_back"];
//        back_imageview.userInteractionEnabled = YES;
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
//        [back_imageview addGestureRecognizer:gesture];
//
//        UILabel *right_title = [[UILabel alloc]init];
//        [_navigationView addSubview:right_title];
//        [right_title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(_navigationView).mas_offset(-10);
//            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
//            make.height.mas_equalTo(30);
//        }];
//        right_title.font = [UIFont systemFontOfSize:14];
//        right_title.text = @"积分记录";
//        right_title.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLog)];
//        [right_title addGestureRecognizer:tap];
//    }
//    return _navigationView;
//}
//
//-(void)toLog{
//    UserScoreDetailViewController *controller = [[UserScoreDetailViewController alloc]init];
//    [self.navigationController pushViewController:controller animated:YES];
//}
//
//-(void)back{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//-(void)hideKey{
//    [self.view endEditing:YES];
//    //    [self.view makeCenterOffsetToast:@"hsdfjklsd;fl"];
//}
//
//-(void)toPay{
//    JiFenModel *model = _list[5];
//    if (!model.money) {
//        OtherMoneyCollectionViewCell *cell = [_collectionview cellForItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
//        if ([cell.edit isEditing]) {
//            [cell.edit endEditing:YES];
//        }
//    }
//
//    if (_lastPayIndexPath.row==0) {
//        [self getOrderInfo:@"wechat"];
//    }else{
//        [self getOrderInfo:@"ali"];
//    }
//}
//
//-(void)getOrderInfo:(NSString *)type{
//    [HZLoadingHUD showHUDInView:self.view];
//    HZHttpClient *client = [HZHttpClient httpClient];
//    JiFenModel *model = _list[_lastIndexPath.row];
//    [client hcPOST:@"/v1/jifen/gopay" parameters:@{@"money":[NSString stringWithFormat:@"%zd",model.money],@"pay_type":type,@"app_type":@"ios"} success:^(NSURLSessionDataTask *task, id object) {
////         [client hcPOST:@"/v1/jifen/gopay" parameters:@{@"money":@"0.01",@"pay_type":type,@"app_type":@"ios"} success:^(NSURLSessionDataTask *task, id object) {
//        if ([object[@"state_code"] isEqualToString:@"0000"]) {
//
//            HZWebBaseViewController *controller = [[HZWebBaseViewController alloc]initWithURL:[NSURL URLWithString:@"https://www.baidu.com/"] actionButtonMode:HZWebActionButtonNone];
//            [self.navigationController pushViewController:controller animated:YES];
//
//        }else  if ([object[@"state_code"] isEqualToString:@"9999"]){
//            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
//            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
//            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
//            [viewController setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:viewController animated:YES];
//        }else{
//            [self.view makeCenterOffsetToast:object[@"msg"]];
//        }
//
//        [HZLoadingHUD hideHUDInView:self.view];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
//        [HZLoadingHUD hideHUDInView:self.view];
//    }];
//}
//
//-(void)weixinPay{
//
//}
//
//-(void)aliPay{
//
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO];
//}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES];
//}
//
//
//@end
//
