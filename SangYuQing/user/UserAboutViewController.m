//
//  UserAboutViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserAboutViewController.h"

@interface UserAboutViewController ()

@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@end

@implementation UserAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
    UIImageView *image = [[UIImageView alloc]init];
    [self.view addSubview:image];
    [image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom).mas_offset(50);
        make.height.mas_equalTo(100);
        make.width.mas_equalTo(100);
    }];
    image.image = [UIImage imageNamed:@"AppIcon"];
    
    UILabel *company = [[UILabel alloc]init];
    [self.view addSubview:company];
    [company mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(image.mas_bottom).mas_offset(20);
    }];
    company.text = @"华晚集团旗下品牌";
    company.font = [UIFont systemFontOfSize:19];
    
    UILabel *app_info = [[UILabel alloc]init];
    [self.view addSubview:app_info];
    [app_info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(company.mas_bottom).mas_offset(20);
    }];
    app_info.text = @"桑榆情ios版 1.0";
    app_info.font = [UIFont systemFontOfSize:15];
    
    
    UILabel *info = [[UILabel alloc]init];
    [self.view addSubview:info];
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(app_info.mas_bottom).mas_offset(100);
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
    }];
    info.textColor = [UIColor darkGrayColor];
    info.numberOfLines = 0;//表示label可以多行显示
    info.text = @"         近两年在社会上提倡“网络祭祀”这可以说是一种新型的祭祀形式也被越来越多的人开始接受尤其是在青年人中比较流行。因为“网络祭祀”既经济又便利既环保又实惠省去了人们用整天的时间去陵园扫墓又免去了因扫墓而引起的多种事故。“网络祭祀”可以说是种既便利可行又节省时间和经济既能表达对亲人的怀念又能强化人们的环保意识。\n\n       桑榆晴APP为用户提供网络祭祀的服务，用户可以在APP中创建墓地，供自己或亲戚朋友在线上香、献花、写祷文等。";
    info.font = [UIFont systemFontOfSize:15];
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
        title.text = @"关于桑榆情";
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
