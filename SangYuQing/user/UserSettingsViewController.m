//
//  UserSettingsViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserSettingsViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserInfoListCell.h"
#import "UIColor+Helper.h"
#import "AddressPickerView.h"
#import "UIColor+Helper.h"
#import "UserAboutViewController.h"
#import "UserRuleViewController.h"
#import "NSFileManager+Helper.h"
#import "UIView+Helper.h"
#import "UIView+ToastHelper.h"
#import "UserManager.h"
#import "UserModel.h"

@interface UserSettingsViewController ()<UITableViewDelegate,UITableViewDataSource,AddressPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic ,strong) UITableView * tableview;
@property (nonatomic ,assign)CGFloat cacheSize;
@end

@implementation UserSettingsViewController

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
    [_tableview registerNib:[UINib nibWithNibName:@"UserInfoListCell" bundle:nil] forCellReuseIdentifier:@"userinfo_cell"];
    
    UIButton *login_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:login_btn];
    [login_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-100);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(200);
    }];
//    login_btn.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
    [login_btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"CD853F"]] forState:UIControlStateNormal];
//     [login_btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"CD853F"]] forState:UIControlStateSelected];
    login_btn.tintColor = [UIColor whiteColor];
    [login_btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [login_btn.layer setMasksToBounds:YES];
    [login_btn.layer setCornerRadius:5];
    [login_btn addTarget:self action:@selector(loginout) forControlEvents:UIControlEventTouchUpInside];
    if (![UserManager ahnUser]) {
        [login_btn removeFromSuperview];
    }
}

-(void)loginout{
    [HZLoadingHUD showHUDInView:self.view];
    
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/login/logout" parameters:nil success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:@"退出登录成功"];
            [UserManager clearAllUser];
            [[NSNotificationCenter defaultCenter] postNotificationName:kZANUserLoginSuccessNotification object:nil];
            [HZLoadingHUD hideHUDInView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
        
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];

}

- (UIImage*) createImageWithColor: (UIColor*) color

{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
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
        title.text = @"设置";
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
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfo_cell"];
    cell.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    switch (indexPath.row) {
        case 0:
            [cell configWithName:@"关于桑榆情" value:nil];
            break;
        case 1:
            [cell configWithName:@"服务条款" value:nil];
            break;
        case 2:{
            _cacheSize = [NSFileManager folderSizeAtPath:[NSFileManager cacheDirectory]];
            NSString * str = [NSString stringWithFormat:@"%.2f M",_cacheSize];
            [cell configWithName:@"清除缓存" value: str];
            break;
        }
            
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
   
    switch (indexPath.row) {
        case 0:{
            UserAboutViewController *controller = [[UserAboutViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 1:{
            UserRuleViewController *controller = [[UserRuleViewController alloc]init];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        case 2:{
            CGFloat cacheSize = [NSFileManager folderSizeAtPath:[NSFileManager cacheDirectory]];
//            [HZLoadingHUD showHUDInView:self.view];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
                [[SDImageCache sharedImageCache] clearMemory];
                [[NSFileManager defaultManager] removeItemAtPath:[NSFileManager cacheDirectory] error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [tableView reloadData];
                     [self.view makeCenterOffsetToast:[NSString stringWithFormat:@"共清理缓存%.2f M", cacheSize]];
                });
            });
            break;
        }
        default:
            break;
    }
}
@end
