//
//  SearchViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "SearchViewController.h"
#import "PrivateTableViewCell.h"
#import "MDDetailViewController.h"
#import "MuDIModel.h"

@interface SearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong) NSMutableArray *array;
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,copy)NSString *keyword;
@property (nonatomic,assign) NSInteger *index;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
    _index = 0;
    _array = [NSMutableArray new];
    _tableview = [[UITableView alloc]init];
    _tableview.tableFooterView = [UIView new];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
//    _tableview.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    _tableview.backgroundColor = [UIColor clearColor];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    _tableview.mj_footer = footer;
    _tableview.mj_footer.automaticallyChangeAlpha = YES;
    
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    _tableview.mj_header.automaticallyChangeAlpha = YES;
    [_tableview registerNib:[UINib nibWithNibName:@"PrivateTableViewCell" bundle:nil] forCellReuseIdentifier:@"siren_cell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PrivateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"siren_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    MuDIModel *model = _array[indexPath.row];
    [cell configWithModel:model];
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 160;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MDDetailViewController *controller = [[MDDetailViewController alloc] init];
    MuDIModel *model = _array[indexPath.row];
    controller.sz_id = model.sz_id;
    controller.cemetery_id = model.cemetery_id;
    [self.navigationController pushViewController:controller animated:YES];
}


// 自定义导航栏
-(UIView *)navigationView{
    
    if(_navigationView == nil){
        _navigationView = [[UIView alloc]init];
        _navigationView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height);
        
        _scaleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64+ [[UIApplication sharedApplication] statusBarFrame].size.height)];
        //        _scaleImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        _scaleImageView.clipsToBounds = YES;
        _scaleImageView.image = [UIImage imageNamed:@"bar_bg"];
        _scaleImageView.alpha = 1;
        [_navigationView addSubview:_scaleImageView];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        [_navigationView addSubview:cancel];
        [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_navigationView).mas_offset(-10);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(40);
        }];
        [cancel setTintColor:[UIColor blackColor]];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        cancel.backgroundColor = [UIColor clearColor];
        [cancel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        UIView  *view = [[UIView alloc]init];
        [_navigationView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_navigationView).mas_offset(10);
            make.right.mas_equalTo(cancel.mas_left).mas_offset(-10);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-10);
            make.height.mas_equalTo(64 -20);
        }];
        view.layer.borderColor = [UIColor colorWithHexString:@"DFDFDF"].CGColor;
        view.layer.borderWidth = 1;
        
        
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_search"]];
        [view addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view);
            make.left.mas_equalTo(view).mas_offset(10);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(30);
        }];
        
        UITextField *edittext = [[UITextField alloc]init];
        edittext.borderStyle = UITextBorderStyleNone;
        [view addSubview:edittext];
        [edittext mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageview.mas_right).mas_offset(10);
            make.right.mas_equalTo(view);
            make.centerY.mas_equalTo(view);
        }];
        edittext.placeholder = @"输入姓名";
        edittext.returnKeyType = UIReturnKeySearch;
        edittext.delegate = self;
    }
    return _navigationView;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    [textField resignFirstResponder];//取消第一响应者
    [textField endEditing:YES];
    _keyword =textField.text;
    [self search];
    
    return YES;
}

-(void)search{
        HZHttpClient *client = [HZHttpClient httpClient];
        [HZLoadingHUD showHUDInView:self.view];
        [client hcGET:@"/v1/gongmu/list" parameters:@{@"name":_keyword,} success:^(NSURLSessionDataTask *task, id object) {
            
            if(object[@"state"]){
                NSLog(@"success");
                NSArray *list = [MTLJSONAdapter modelsOfClass:[MuDIModel class] fromJSONArray:object[@"data"][@"CemeteryData"] error:nil];
                [_array addObjectsFromArray:list];
                if (_array.count<=0) {
                    [self.view makeCenterOffsetToast:@"没有结果"];
                }
                [_tableview reloadData];
            }else{
                [self.view makeCenterOffsetToast:object[@"msg"]];
            }
            [HZLoadingHUD hideHUDInView:self.view];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.view makeCenterOffsetToast:@"请求失败，请重试"];
            [HZLoadingHUD hideHUDInView:self.view];
        }];

}

-(void)headerRefreshing{
    _index = 0;
    [_array removeAllObjects];
    [self search];
    [_tableview.mj_header endRefreshing];
}

-(void)footerRereshing{
    _index++;
    [self search];
    [_tableview.mj_footer endRefreshing];
    
}


-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
