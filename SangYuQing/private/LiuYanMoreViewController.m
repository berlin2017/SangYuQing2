//
//  LiuYanMoreViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LiuYanMoreViewController.h"
#import "HZRefreshTableView.h"
#import "ZhuiSiLiuYanTableViewCell.h"
#import "LiuYanModel.h"
#import "UserLoginViewController.h"

@interface LiuYanMoreViewController ()<HZRefreshTableDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property(nonatomic,strong)HZRefreshTableView *tableview;
@property(nonatomic,strong)NSMutableArray *list;
@end

@implementation LiuYanMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    _list = [NSMutableArray new];
    _tableview = [[HZRefreshTableView alloc]init];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
    }];
    
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.delegate = self;
    _tableview->_tableView.delegate = self;
    _tableview.realTableViewDataSource = self;
    _tableview->_tableView.estimatedSectionHeaderHeight = 0;
    _tableview->_tableView.estimatedSectionFooterHeight = 0;
    _tableview.refreshStyle = HZRefreshTableStyleHeader;
    [_tableview->_tableView registerNib:[UINib nibWithNibName:@"ZhuiSiLiuYanTableViewCell" bundle:nil] forCellReuseIdentifier:@"zhuisi_liuyan_cell"];
    [self requestList];
}
-(void)updateUserModel{
    [self requestList];
}

-(void)requestList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/gongmu/liuyan" parameters:@{@"id":_sz_id}  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            NSArray *list = [MTLJSONAdapter modelsOfClass:[LiuYanModel class] fromJSONArray:object[@"data"][@"CemeteryInfo"][@"liuyans"] error:nil];
            [_list addObjectsFromArray:list];
            [_tableview->_tableView reloadData];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZhuiSiLiuYanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zhuisi_liuyan_cell"];
    LiuYanModel *model = _list[indexPath.row];
    [cell configWithModel:model];
    cell.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //设置按钮(它默认第一个是修改系统的)
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"删除");
        LiuYanModel*model = _list[indexPath.row];
        HZHttpClient *client = [HZHttpClient httpClient];
        [client hcGET:@"/v1/liuyan/del" parameters:@{@"id":[NSString stringWithFormat:@"%zd",model.szly_id]} success:^(NSURLSessionDataTask *task, id object) {
            if ([object[@"state_code"] isEqualToString:@"0000"]) {
                [self headerRefresh];
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
    
    if(_type==1){
        return @[action];
    }
    return @[];
}


-(void)headerRefresh{
    [_list removeAllObjects];
    [self requestList];
    [_tableview endAllRefreshing];
}

-(void)footerRefresh{
    
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
        title.text = @"留言管理";
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
    }
    return _navigationView;
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
