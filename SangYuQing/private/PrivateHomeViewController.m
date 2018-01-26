//
//  PrivateHomeViewController.m
//  SangYuQing
//
//  Created by mac on 2017/12/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PrivateHomeViewController.h"
#import "PrivateTableViewCell.h"
#import "PrivateTopTableViewCell.h"
#import "UIColor+Helper.h"
#import "PrivateMoreViewController.h"
#import "PrivateCreateViewController.h"
#import "MDDetailViewController.h"
#import "MuDIModel.h"
#import "UserLoginViewController.h"
#import "MyLikeViewController.h"
#import "MyGuanZhuTableViewCell.h"
#import "MuDiEditViewController.h"

@interface PrivateHomeViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property(nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *followarray;
@property (nonatomic,strong) NSMutableArray *creatarray;
@end

@implementation PrivateHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:@"follow.notification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:@"creat.notification" object:nil];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    
    _followarray = [NSMutableArray new];
    _creatarray = [NSMutableArray new];
    _tableview = [[UITableView alloc]init];
    [self.view addSubview:_tableview];
    _tableview.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(-[[UIApplication sharedApplication] statusBarFrame].size.height);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(updateUserModel)];
    _tableview.mj_header.automaticallyChangeAlpha = YES;
    [_tableview registerNib:[UINib nibWithNibName:@"PrivateTableViewCell" bundle:nil] forCellReuseIdentifier:@"siren_cell"];
    [_tableview registerNib:[UINib nibWithNibName:@"PrivateTopTableViewCell" bundle:nil] forCellReuseIdentifier:@"siren_top_cell"];
    [_tableview registerNib:[UINib nibWithNibName:@"MyGuanZhuTableViewCell" bundle:nil] forCellReuseIdentifier:@"guanzhu_cell"];
    [self.view addSubview:self.navigationView];
    
    [self requestList];
    [self requestList2];
}


-(void)updateUserModel{
    [self requestList];
    [self requestList2];
    [_tableview.mj_header endRefreshing];
}

-(void)requestList{
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/gongmu/myfollow" parameters:nil success:^(NSURLSessionDataTask *task, id object) {
        
        if (![object[@"state_code"] isEqualToString:@"9999"]) {
            NSArray *list = [MTLJSONAdapter modelsOfClass:[MuDIModel class] fromJSONArray:object[@"data"][@"followCemetery"] error:nil];
            [_followarray removeAllObjects];
            [_followarray addObjectsFromArray:list];
            [_tableview reloadData];
        }else{
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            //            [UserManager clearAllUser];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kZANUserLoginSuccessNotification object:nil];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
}

-(void)requestList2{
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/cemetery/mylist" parameters:nil success:^(NSURLSessionDataTask *task, id object) {
        
        if (![object[@"state_code"] isEqualToString:@"9999"]) {
            NSArray *list = [MTLJSONAdapter modelsOfClass:[MuDIModel class] fromJSONArray:object[@"data"][@"cemeteryData"] error:nil];
            [_creatarray removeAllObjects];
            [_creatarray addObjectsFromArray:list];
            [_tableview reloadData];
        }else{
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            //            [UserManager clearAllUser];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kZANUserLoginSuccessNotification object:nil];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    if(section==1){
        return _creatarray.count;
    }
    
    if(section==2){
        return _followarray.count;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        PrivateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"siren_cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        MuDIModel *model = _creatarray[indexPath.row];
        [cell configWithModel:model];
        return cell;
    }else if(indexPath.section==2){
        MyGuanZhuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"guanzhu_cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        MuDIModel *model = _followarray[indexPath.row];
        [cell configWithModel:model];
        return cell;
    }
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(-1, -1, [UIScreen mainScreen].bounds.size.width, 40)];
        view.userInteractionEnabled = YES;
        UIImageView *imageview = [[UIImageView alloc]init];
        [view addSubview:imageview];
        imageview.image = [UIImage imageNamed:@"siren_item_header"];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view).mas_offset(10);
            make.centerY.mas_equalTo(view);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
        UILabel *label = [[UILabel alloc]init];
        if(section==2){
            label.text = @"我关注的墓地";
        }else{
            label.text = @"我创建的墓地";
        }
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageview.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(view);
        }];
        
        UILabel *label2 = [[UILabel alloc]init];
        label2.text = @"查看全部>>";
        label2.font = [UIFont systemFontOfSize:12];
        [view addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view).mas_offset(-10);
            make.centerY.mas_equalTo(view);
        }];
        label2.userInteractionEnabled = YES;
        label2.tag = 2000+section;
        UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toMore:)];
        [label2 addGestureRecognizer:labelTapGestureRecognizer];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexRGB:0x000000 alpha:0.1];
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view);
            make.left.mas_equalTo(view);
            make.bottom.mas_equalTo(view);
            make.height.mas_equalTo(1);
        }];
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250)];
        view.userInteractionEnabled = YES;
        UIImageView *imageview = [[UIImageView alloc]init];
        [view addSubview:imageview];
        imageview.image = [UIImage imageNamed:@"siren_home_top"];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
        return view;
    }
    return nil;
}

-(void)toMore:(UITapGestureRecognizer*)gesture{
    if (gesture.view.tag==2001) {
        PrivateMoreViewController *controller = [[PrivateMoreViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        MyLikeViewController *controller = [[MyLikeViewController alloc]init];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(indexPath.section==0){
    //        return 400;
    //    }
    return 160;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 40;
    }else{
        return 250;
    }
}

//#pragma mark -- 代理方法
////实现了这个方法就有滑动的删除按钮了
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

//这个方法就是可以自己添加一些侧滑出来的按钮，并执行一些命令和按钮设置
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //设置按钮(它默认第一个是修改系统的)
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
        MuDIModel*model = _creatarray[indexPath.row];
        HZHttpClient *client = [HZHttpClient httpClient];
        [client hcPOST:@"/v1/cemetery/delcemetery" parameters:@{@"id":model.cemetery_id} success:^(NSURLSessionDataTask *task, id object) {
            if ([object[@"state_code"] isEqualToString:@"0000"]) {
                [self requestList2];
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
    //设置按钮(它默认第一个是修改系统的)
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        //执行跳转到下个界面操作
        MuDiEditViewController *vc = [[MuDiEditViewController alloc]init];
        MuDIModel *model = _creatarray[indexPath.row];
        vc.model = model;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"取消关注" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"取消关注");
        MuDIModel*model = _followarray[indexPath.row];
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
    
    
    if(indexPath.section==1){
        return @[action,action1];
    }else if (indexPath.section==2){
        return @[action2];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDDetailViewController *controller = [[MDDetailViewController alloc]init];
    
    if (indexPath.section==1) {
        MuDIModel *model = _creatarray[indexPath.row];
        controller.sz_id = model.sz_id;
        controller.cemetery_id = model.cemetery_id;
    }else{
        MuDIModel *model = _followarray[indexPath.row];
        controller.sz_id = model.sz_id;
        controller.cemetery_id = model.cemetery_id;
    }
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


// 自定义导航栏
-(UIView *)navigationView{
    
    if(_navigationView == nil){
        _navigationView = [[UIView alloc]init];
        _navigationView.userInteractionEnabled = YES;
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
        title.text = @"私人墓园";
        
        UILabel *right_label = [[UILabel alloc]init];
        right_label.userInteractionEnabled = YES;
        [_navigationView addSubview:right_label];
        [right_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(title);
            make.right.mas_equalTo(_navigationView).mas_offset(-10);;
        }];
        right_label.font = [UIFont systemFontOfSize:14];
        right_label.text = @"快速建墓";
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclickRightMenu)];
        [right_label addGestureRecognizer:gesture];
    }
    return _navigationView;
}

-(void)onclickRightMenu{
    PrivateCreateViewController *controller = [[PrivateCreateViewController alloc]init];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
