//
//  MyLikeViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyLikeViewController.h"
#import "PrivateTableViewCell.h"
#import "PrivateTopTableViewCell.h"
#import "UIColor+Helper.h"
#import "HZHttpClient.h"
#import "UserModel.h"
#import "UserManager.h"
#import "UserLoginViewController.h"
#import "MuDIModel.h"
#import "MyGuanZhuTableViewCell.h"
#import "MDDetailViewController.h"

@interface MyLikeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong)UITableView *tableview;
@end

@implementation MyLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    //    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    //    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:@"follow.notification" object:nil];
    _array = [NSMutableArray new];
    
    _tableview = [[UITableView alloc]init];
    [self.view addSubview:_tableview];
    //    tableview.backgroundColor = [UIColor clearColor];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.tableFooterView = [UIView new];
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableview.mj_header.automaticallyChangeAlpha = YES;
    [_tableview registerNib:[UINib nibWithNibName:@"MyGuanZhuTableViewCell" bundle:nil] forCellReuseIdentifier:@"guanzhu_cell"];
    //    [tableview registerNib:[UINib nibWithNibName:@"PrivateTopTableViewCell" bundle:nil] forCellReuseIdentifier:@"siren_top_cell"];
    
    [self requestList];
}

-(void)headerRefreshing{
    [_array removeAllObjects];
    [self requestList];
}

-(void)updateUserModel{
    [self requestList];
}

-(void)requestList{
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/gongmu/myfollow" parameters:nil success:^(NSURLSessionDataTask *task, id object) {
        
        if (![object[@"state_code"] isEqualToString:@"9999"]) {
            NSArray *list = [MTLJSONAdapter modelsOfClass:[MuDIModel class] fromJSONArray:object[@"data"][@"followCemetery"] error:nil];
            [_array addObjectsFromArray:list];
            [_tableview reloadData];
        }else{
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            //            [UserManager clearAllUser];
            //             [[NSNotificationCenter defaultCenter] postNotificationName:kZANUserLoginSuccessNotification object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        [_tableview.mj_header endRefreshing];
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
        [_tableview.mj_header endRefreshing];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyGuanZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guanzhu_cell" forIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor clearColor];
    MuDIModel *model = _array[indexPath.row];
    [cell configWithModel:model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDDetailViewController *controller = [[MDDetailViewController alloc]init];
    
    MuDIModel *model = _array[indexPath.row];
    controller.sz_id = model.sz_id;
    controller.cemetery_id = model.cemetery_id;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

//这个方法就是可以自己添加一些侧滑出来的按钮，并执行一些命令和按钮设置
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"取消关注");
        MuDIModel*model = _array[indexPath.row];
        HZHttpClient *client = [HZHttpClient httpClient];
        [client hcGET:@"/v1/gongmu/follow" parameters:@{@"cemetery_id":model.cemetery_id,@"type":@"0"} success:^(NSURLSessionDataTask *task, id object) {
            if ([object[@"state_code"] isEqualToString:@"0000"]) {
                [self requestList];
            }else if([object[@"state_code"] isEqualToString:@"9999"]){
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
    }];
    
    return @[action2];
    
}


// 自定义导航栏
-(UIView *)navigationView{
    
    if(_navigationView == nil){
        _navigationView = [[UIView alloc]init];
        _navigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height);
        
        _scaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height)];
        _scaleImageView.image = [UIImage imageNamed:@"bar_bg"];
        //        _scaleImageView.alpha = 0;
        [_navigationView addSubview:_scaleImageView];
        
        UILabel *title = [[UILabel alloc]init];
        [_navigationView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_navigationView);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
            make.height.mas_equalTo(30);
        }];
        title.font = [UIFont systemFontOfSize:17];
        
        title.text = @"我的关注";
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
