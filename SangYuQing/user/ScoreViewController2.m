//
//  UserScoreViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ScoreViewController2.h"
#import "UserScoreCollectionViewCell.h"
#import "UIColor+Helper.h"
#import "UIView+ToastHelper.h"
#import "UserScorePayCollectionViewCell.h"
#import "UserScoreDetailViewController.h"
#import "UserModel.h"
#import "UserManager.h"
#import "UserLoginViewController.h"
#import "OtherMoneyCollectionViewCell.h"
#import "JiFenModel.h"
#import "HZWebBaseViewController.h"
#import <StoreKit/StoreKit.h>
#import<CommonCrypto/CommonDigest.h>

@interface ScoreViewController2 ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,SKPaymentTransactionObserver,SKProductsRequestDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property(nonatomic,copy)NSIndexPath *lastIndexPath;
@property(nonatomic,copy)NSIndexPath *lastPayIndexPath;
@property(nonatomic,copy)UILabel *score;
@property (nonatomic,strong)UICollectionView *collectionview;
@property (nonatomic,strong)UICollectionView *collectionview2;
@property (nonatomic,copy)NSMutableArray *list;
@end

@implementation ScoreViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([SKPaymentQueue canMakePayments]) {
        NSLog(@"允许程序内付费购买");
    }else{
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机没有打开程序内付费购买"
                                                          delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        [alerView show]; }
    
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payWXSuccess) name:@"wx.pay.success" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payAliSuccess:) name:@"ali.pay.success" object:nil];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *key_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKey)];
    //    [self.view addGestureRecognizer:key_recognizer];
    _list = [NSMutableArray new];
    JiFenModel *model = [[JiFenModel alloc]init];
    model.jifen = 100;
    model.money = 10;
    model.apple_id = @"SangYuQing10";
    [_list addObject:model];
    
    JiFenModel *model2 = [[JiFenModel alloc]init];
    model2.jifen = 500;
    model2.money = 50;
    model2.apple_id = @"SangYuQing0";
    [_list addObject:model2];
    JiFenModel *model3 = [[JiFenModel alloc]init];
    model3.jifen = 1000;
    model3.money = 100;
    model3.apple_id = @"SangYuQing100";
    [_list addObject:model3];
    JiFenModel *model4 = [[JiFenModel alloc]init];
    model4.jifen = 2000;
    model4.money = 200;
    model4.apple_id = @"SangYuQing200";
    [_list addObject:model4];
    JiFenModel *model5 = [[JiFenModel alloc]init];
    model5.jifen = 3000;
    model5.money = 300;
    model5.apple_id = @"SangYuQing300";
    [_list addObject:model5];
    JiFenModel *model6 = [[JiFenModel alloc]init];
    model6.jifen = 5000;
    model6.money = 500;
    model6.apple_id = @"SangYuQing500";
    [_list addObject:model6];
    
    _lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _lastPayIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UIScrollView * scrollview = [[UIScrollView alloc]init];
    [self.view addSubview:scrollview];
    scrollview.userInteractionEnabled = YES;
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
    }];
    
    UIView *contentview = [[UIView alloc]init];
    [scrollview addSubview:contentview];
    contentview.userInteractionEnabled = YES;
    
    UIView *topview = [[UIView alloc]init];
    [contentview addSubview:topview];
    topview.userInteractionEnabled = YES;
    [topview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.top.mas_equalTo(self.navigationView.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(100);
    }];
    UIImageView *bg = [[UIImageView alloc]init];
    [topview addSubview:bg];
    [bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(topview);
    }];
    bg.image = [UIImage imageNamed:@"user_jifen_bg"];
    
    
    _score = [[UILabel alloc]init];
    [topview addSubview:_score];
    [_score mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(topview);
    }];
    if ([UserManager ahnUser]) {
        UserModel *user = [UserManager ahnUser];
        _score.text = [NSString stringWithFormat:@"%zd",user.bonus_point];
    }else{
        _score.text = @"0";
    }
    
    _score.font = [UIFont systemFontOfSize:19];
    
    
    
    UILabel *name = [[UILabel alloc]init];
    [topview addSubview:name];
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topview);
        make.right.mas_equalTo(_score.mas_left).mas_offset(-40);
    }];
    name.text = @"当前积分:";
    name.font = [UIFont systemFontOfSize:15];
    
    UILabel *jifen = [[UILabel alloc]init];
    [topview addSubview:jifen];
    [jifen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topview);
        make.left.mas_equalTo(_score.mas_right).mas_offset(40);
    }];
    jifen.text = @"积分";
    jifen.font = [UIFont systemFontOfSize:15];
    
    
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-60)/3 , 60);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    _collectionview.tag = 1000;
    _collectionview.userInteractionEnabled = YES;
    [_collectionview registerNib:[UINib nibWithNibName:@"UserScoreCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"score_jifen_cell"];
    [_collectionview registerNib:[UINib nibWithNibName:@"OtherMoneyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"other_cell"];
    [contentview addSubview:_collectionview];
    
    _collectionview.backgroundColor = [UIColor clearColor];
    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.top.mas_equalTo(topview.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(60*2+20);
    }];
    
    [_collectionview selectItemAtIndexPath:_lastIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    UICollectionViewFlowLayout *layout2 = [UICollectionViewFlowLayout new];
    layout2.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-60)/2 , 50);
    layout2.minimumLineSpacing = 10;
    layout2.minimumInteritemSpacing = 10;
    _collectionview2 = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout2];
    _collectionview2.delegate = self;
    _collectionview2.dataSource = self;
    _collectionview2.tag = 2000;
    _collectionview2.userInteractionEnabled = YES;
    [_collectionview2 registerNib:[UINib nibWithNibName:@"UserScorePayCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"score_pay_cell"];
    //    [contentview addSubview:_collectionview2];
    //    _collectionview2.backgroundColor = [UIColor clearColor];
    //    [_collectionview2 mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.mas_equalTo(self.view).mas_offset(10);
    //        make.right.mas_equalTo(self.view).mas_offset(-10);
    //        make.top.mas_equalTo(_collectionview.mas_bottom).mas_offset(20);
    //        make.height.mas_equalTo(60);
    //    }];
    
    [_collectionview2 selectItemAtIndexPath:_lastPayIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [contentview addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width*0.6);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_collectionview.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    btn.userInteractionEnabled = YES;
    [btn setTitle:@"确认支付" forState: UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    btn.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(toPay) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *bottom_name = [[UILabel alloc]init];
    [contentview addSubview:bottom_name];
    [bottom_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).mas_offset(40);
        make.left.mas_equalTo(self.view).mas_equalTo(10);
        make.right.mas_equalTo(self.view).mas_equalTo(-10);
    }];
    bottom_name.text = @"支付说明";
    bottom_name.userInteractionEnabled = YES;
    bottom_name.font = [UIFont systemFontOfSize:19];
    
    UILabel *bottom_detail = [[UILabel alloc]init];
    [contentview addSubview:bottom_detail];
    [bottom_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottom_name.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.view).mas_equalTo(10);
        make.right.mas_equalTo(self.view).mas_equalTo(-10);
    }];
    bottom_detail.numberOfLines = 0;
    bottom_detail.text = @"您可在此将拥有的积分进行充值，以满足在不同场合的消费需求。";
    bottom_detail.font = [UIFont systemFontOfSize:15];
    
    UILabel *bottom_name2 = [[UILabel alloc]init];
    [contentview addSubview:bottom_name2];
    [bottom_name2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottom_detail.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.view).mas_equalTo(10);
        make.right.mas_equalTo(self.view).mas_equalTo(-10);
    }];
    bottom_name2.text = @"兑换说明";
    bottom_name2.font = [UIFont systemFontOfSize:19];
    
    UILabel *bottom_detail2 = [[UILabel alloc]init];
    [contentview addSubview:bottom_detail2];
    [bottom_detail2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottom_name2.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.view).mas_equalTo(10);
        make.right.mas_equalTo(self.view).mas_equalTo(-10);
    }];
    bottom_detail2.numberOfLines = 0;
    bottom_detail2.text = @"1元=10积分";
    bottom_detail2.font = [UIFont systemFontOfSize:15];
    
    [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.bottom.mas_equalTo(bottom_detail2.mas_bottom);
        make.right.mas_equalTo(self.view);
    }];
    
    [self getJiFen];
}


-(void)getJiFen{
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/ucenter/my-jifen" parameters:nil success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            long jifen = [object[@"data"][@"jifen"] longValue];
            UserModel *user = [UserManager ahnUser];
            user.bonus_point = jifen;
            [UserManager saveAhnUser:user];
            _score.text = [NSString stringWithFormat:@"%zd",jifen];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"user.jifen.change" object:nil];
        }else  if ([object[@"state_code"] isEqualToString:@"9999"]){
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [viewController setHidesBottomBarWhenPushed:YES];
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

-(void)updateUserModel{
    [self getJiFen];
}


#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1000) {
        return _list.count;
    }
    return 2;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1000) {
        JiFenModel *model = _list[indexPath.row];
        //        if (indexPath.row==5&&!model.money) {
        //            OtherMoneyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"other_cell" forIndexPath:indexPath];
        //            cell.edit.backgroundColor = [UIColor clearColor];
        //            cell.edit.text = @"其他";
        //            cell.edit.delegate = self;
        //            return cell;
        //        }
        UserScoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"score_jifen_cell" forIndexPath:indexPath];
        if(indexPath==_lastIndexPath){
            [cell setBackColor:[UIColor colorWithHexString:@"CD853F"]];
        }else{
            [cell setBackColor:[UIColor clearColor]];
        }
        [cell configWithModel:_list[indexPath.row]];
        return cell;
    }else{
        UserScorePayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"score_pay_cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        [cell configWithIndex:indexPath.row];
        if (indexPath==_lastPayIndexPath) {
            [cell setBoraderColor:[UIColor colorWithHexString:@"CD853F"]];
        }
        return cell;
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"cell #%d was selected", indexPath.row);
    if (collectionView.tag == 1000) {
        //        if (indexPath.row!=5) {
        //            [_list removeObjectAtIndex:5];
        //            JiFenModel *model = [[JiFenModel alloc]init];
        //            [_list addObject:model];
        //            [collectionView reloadData];
        //        }
    }
    return;
}

//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (collectionView.tag == 1000) {
        if (indexPath!=_lastIndexPath) {
            UserScoreCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath ];
            [cell setBackColor:[UIColor colorWithHexString:@"CD853F"]];
            UserScoreCollectionViewCell *cell2 = [collectionView cellForItemAtIndexPath:_lastIndexPath ];
            [cell2 setBackColor:[UIColor clearColor]];
            _lastIndexPath = indexPath;
        }
    }else if(collectionView.tag == 2000){
        if (indexPath!=_lastPayIndexPath) {
            UserScorePayCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath ];
            [cell setBoraderColor:[UIColor colorWithHexString:@"CD853F"]];
            UserScorePayCollectionViewCell *cell2 = [collectionView cellForItemAtIndexPath:_lastPayIndexPath ];
            [cell2 setBoraderColor:[UIColor clearColor]];
            _lastPayIndexPath = indexPath;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1000) {
        UserScoreCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [cell setBackColor:[UIColor colorWithHexString:@"CD853F"]];
    }else if(collectionView.tag == 2000){
        if (indexPath!=_lastPayIndexPath) {
            UserScorePayCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath ];
            [cell setBoraderColor:[UIColor clearColor]];
        }
    }
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
    textField.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
    UserScoreCollectionViewCell *cell2 = [_collectionview cellForItemAtIndexPath:_lastIndexPath];
    [cell2 setBackColor:[UIColor clearColor]];
    _lastIndexPath = [NSIndexPath indexPathForRow:5 inSection:0];
}

-(void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    JiFenModel *model =  _list[5];
    model.jifen = [textField.text integerValue]*10;
    model.money = [textField.text integerValue];
    [_collectionview reloadData];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self.view endEditing:YES];
    
    return YES;
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
        title.text = @"我的积分";
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
        right_title.text = @"积分记录";
        right_title.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toLog)];
        [right_title addGestureRecognizer:tap];
    }
    return _navigationView;
}

-(void)toLog{
    UserScoreDetailViewController *controller = [[UserScoreDetailViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hideKey{
    [self.view endEditing:YES];
    //    [self.view makeCenterOffsetToast:@"hsdfjklsd;fl"];
}

-(void)toPay{
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
     [HZLoadingHUD showHUDInView:self.view];
    JiFenModel *model = _list[_lastIndexPath.row];
    SKPayment *payment = [SKPayment paymentWithProductIdentifier:model.apple_id];
     [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    NSLog(@"-----paymentQueue--------");
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                //交易完成 [self  completeTransaction:transaction];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
               [HZLoadingHUD hideHUDInView:self.view];
                NSLog(@"-----交易完成 --------");
                [self addJifen];
             
            } break;
            case SKPaymentTransactionStateFailed://交易失败
                
            {
                  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                 [HZLoadingHUD hideHUDInView:self.view];
                NSLog(@"失败");
                if (transaction.error.code != SKErrorPaymentCancelled) { }
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                NSLog(@"-----交易失败 --------");
                UIAlertView *alerView2 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"购买失败，请重新尝试购买" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                [alerView2 show];
            }break;
                
            case SKPaymentTransactionStateRestored://已经购买过该商品 [self restoreTransaction:transaction];
                  [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:
                //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                break
                ; default:
                break;
        }
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
   
}

- (NSString *) md5:(NSString *) input {
    
    const char *cStr = [input UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        
        [output appendFormat:@"%02x", digest[i]];
    
    
    
    return  output;
    
}





-(void)addJifen{
   
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    JiFenModel *model = _list[_lastIndexPath.row];
     NSString *sign = [self md5:[NSString stringWithFormat:@"num=%zdsecret=%@uid=%zd",model.jifen,@"sSangyYuqQing",[UserManager ahnUser].user_id]];
    [client hcPOST:@"/v1/jifen/pay" parameters:@{@"num":[NSString stringWithFormat:@"%zd",model.jifen],@"uid":[NSString stringWithFormat:@"%zd",[UserManager ahnUser].user_id],@"sign":sign} success:^(NSURLSessionDataTask *task, id object) {
        //         [client hcPOST:@"/v1/jifen/gopay" parameters:@{@"money":@"0.01",@"pay_type":type,@"app_type":@"ios"} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"购买成功" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
            [alerView show];
            [self getJiFen];
            
        }else  if ([object[@"state_code"] isEqualToString:@"9999"]){
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [viewController setHidesBottomBarWhenPushed:YES];
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

-(void)getOrderInfo:(NSString *)type{
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    JiFenModel *model = _list[_lastIndexPath.row];
    [client hcPOST:@"/v1/jifen/gopay" parameters:@{@"money":[NSString stringWithFormat:@"%zd",model.money],@"pay_type":type,@"app_type":@"ios"} success:^(NSURLSessionDataTask *task, id object) {
        //         [client hcPOST:@"/v1/jifen/gopay" parameters:@{@"money":@"0.01",@"pay_type":type,@"app_type":@"ios"} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            
            HZWebBaseViewController *controller = [[HZWebBaseViewController alloc]initWithURL:[NSURL URLWithString:@"https://www.baidu.com/"] actionButtonMode:HZWebActionButtonNone];
            [self.navigationController pushViewController:controller animated:YES];
            
        }else  if ([object[@"state_code"] isEqualToString:@"9999"]){
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [viewController setHidesBottomBarWhenPushed:YES];
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

-(void)weixinPay{
    
}

-(void)aliPay{
    
}

-(void)viewDidDisappear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:NO];
     // 移除观察者
      [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
//    [self.navigationController setNavigationBarHidden:YES];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}


@end


