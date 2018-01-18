//
//  UserFrogetPassViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserFrogetPassViewController.h"
#import "UIView+ToastHelper.h"

@interface UserFrogetPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone_edit;
@property (weak, nonatomic) IBOutlet UITextField *code_edit;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *pass_edit;
@property (weak, nonatomic) IBOutlet UIButton *commit_btn;
@property(nonatomic,assign) BOOL isRightPhone;
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@end

@implementation UserFrogetPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *key_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:key_recognizer];
    
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 5;
    [_sendBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    
}
- (IBAction)commit:(id)sender {
    
     [self checkPhone:_phone_edit.text];
    if (!_isRightPhone) {
        return;
    }
    
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/login/findpasswordsecond" parameters:@{@"mobile":_phone_edit.text,@"verdata":_code_edit.text,@"password":_pass_edit.text,@"repassword":_pass_edit.text} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:@"密码修成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
    }];
}

-(void)sendCode{
    [self checkPhone:_phone_edit.text];
    if (!_isRightPhone) {
        return;
    }
    
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/login/getcode" parameters:@{@"mobile":_phone_edit.text} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:@"验证码发送成功"];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
    }];
}

-(void)checkPhone:(NSString *)phone{
    if ([NSString isEmptyString:phone]) {
        [self.view makeCenterOffsetToast:@"手机号不能为空"];
        return;
    }
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/login/findpasswordfirst" parameters:@{@"mobile":phone} success:^(NSURLSessionDataTask *task, id object) {
        if (![object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }else{
            _isRightPhone = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
    }];
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
        title.text = @"忘记密码";
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

-(void)hideKey{
    [self.view endEditing:YES];
}

@end
