//
//  MuDiEditViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MuDiEditViewController.h"
#import "PrivateCreateViewController.h"
#import "BeijingMubeiViewController.h"
#import "MuDIModel.h"
#import "WriteJiWenViewController.h"
#import "JiWenMoreViewController.h"
#import "LiuYanMoreViewController.h"
#import "XiangCeGuanLIViewController.h"
#import "VideoGuanLiViewController.h"

@interface MuDiEditViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic ,strong) UITableView * tableview;

@end

@implementation MuDiEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
    _tableview = [[UITableView alloc]init];
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.tableFooterView = [UIView new];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"bianji_cell"];
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
        title.text = @"墓园编辑";
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"bianji_cell"];
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 0:
            if(indexPath.row==0){
                cell.textLabel.text = @"基本信息";
            }else{
                cell.textLabel.text = @"背景墓碑";
            }
            break;
            
        case 1:
            if(indexPath.row==0){
                cell.textLabel.text = @"追思一生";
            }else if(indexPath.row==1){
                cell.textLabel.text = @"祭文管理";
            } if(indexPath.row==2){
                cell.textLabel.text = @"留言管理";
            }
            break;
        case 2:
            if(indexPath.row==0){
                cell.textLabel.text = @"相册管理";
            }else{
                cell.textLabel.text = @"视频管理";
            }
            break;
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 10;
    }
    return CGFLOAT_MIN;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            PrivateCreateViewController *controller = [[PrivateCreateViewController alloc]init];
            controller.model = _model;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(indexPath.row==1){
            BeijingMubeiViewController *controller = [[BeijingMubeiViewController alloc]init];
            controller.sz_id = _model.sz_id;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            WriteJiWenViewController *controller = [[WriteJiWenViewController alloc]init];
            controller.sz_id = _model.sz_id;
            controller.type = 1;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(indexPath.row==1){
            JiWenMoreViewController *controller = [[JiWenMoreViewController alloc]init];
             controller.sz_id = _model.sz_id;
            controller.type = 1;
             [self.navigationController pushViewController:controller animated:YES];
        }else if(indexPath.row==2){
            LiuYanMoreViewController *controller = [[LiuYanMoreViewController alloc]init];
            controller.sz_id = _model.sz_id;
            controller.type = 1;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            XiangCeGuanLIViewController *controller = [[XiangCeGuanLIViewController alloc]init];
            controller.sz_id = _model.sz_id;
            [self.navigationController pushViewController:controller animated:YES];
        }else if(indexPath.row==1){
            VideoGuanLiViewController *controller = [[VideoGuanLiViewController alloc]init];
            controller.sz_id = _model.sz_id;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}

@end
