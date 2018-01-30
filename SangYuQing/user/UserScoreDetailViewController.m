//
//  UserScoreDetailViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserScoreDetailViewController.h"
#import "UserScoreLogTableViewCell.h"
#import "JiFenDetailModel.h"
#import "HZRefreshTableView.h"
#import "UserLoginViewController.h"

@interface UserScoreDetailViewController ()<UITableViewDelegate,UITableViewDataSource,HZRefreshTableDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,assign) int page;
@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) HZRefreshTableView *tableview;
@end

@implementation UserScoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    _list = [NSMutableArray new];
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
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
    _tableview.refreshStyle = HZRefreshTableStyleHeader|HZRefreshTableStyleFooter;
    [_tableview->_tableView registerNib:[UINib nibWithNibName:@"UserScoreLogTableViewCell" bundle:nil] forCellReuseIdentifier:@"score_detail_cell"];
    [self requestList];
}

-(void)headerRefresh{
    _page = 1;
    [self requestList];
    [_tableview endAllRefreshing];
}

-(void)footerRefresh{
    _page ++;
    [self requestList];
    [_tableview endAllRefreshing];
}

-(void)requestList{
     [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/jifen/list" parameters:@{@"type":@"0",@"page":[NSString stringWithFormat:@"%zd",_page]} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            NSArray *list = [MTLJSONAdapter modelsOfClass:[JiFenDetailModel class] fromJSONArray:object[@"data"][@"jifenData"] error:nil];
            if (_page==1) {
                [_list removeAllObjects];
            }
            [_list addObjectsFromArray:list];
            [_tableview->_tableView reloadData];
        }
        else if([object[@"state_code"] isEqualToString:@"8888"]||[object[@"state_code"] isEqualToString:@"9999"]){
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _list.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserScoreLogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"score_detail_cell"];
    cell.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    JiFenDetailModel *model = _list[indexPath.row];
    [cell configWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
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
        title.text = @"积分记录";
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
