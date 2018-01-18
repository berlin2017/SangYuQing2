//
//  UserRegisterViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "UIView+ToastHelper.h"
#import "UserRuleViewController.h"

@interface UserRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *toLogin_label;
@property (weak, nonatomic) IBOutlet UIImageView *checkBox;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property(nonatomic,assign) BOOL isChecked;
@property(nonatomic,assign) BOOL isRightName;
@property(nonatomic,assign) BOOL isRightPhone;
@property (strong, nonatomic) IBOutlet UIControl *contentView;
@property (weak, nonatomic) IBOutlet UITextField *name_edit;
@property (weak, nonatomic) IBOutlet UITextField *pass_edit1;
@property (weak, nonatomic) IBOutlet UITextField *pass_edit2;
@property (weak, nonatomic) IBOutlet UITextField *phone_edit;
@property (weak, nonatomic) IBOutlet UITextField *code_edit;
@end

@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"user_login_bg"]];
    [self.view setBackgroundColor:bgColor];
    
    _isChecked = NO;
    _isRightName = NO;
    _isRightPhone = NO;
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *key_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:key_recognizer];
    
    _toLogin_label.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tologin)];
    [_toLogin_label addGestureRecognizer:recognizer];
    
    _checkBox.userInteractionEnabled = YES;
    UITapGestureRecognizer *check_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(checkChanged)];
    [_checkBox addGestureRecognizer:check_recognizer];
    
    _ruleLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *rule_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toRule)];
    [_ruleLabel addGestureRecognizer:rule_recognizer];
    
    [_sendBtn addTarget:self action:@selector(sendCode) forControlEvents:UIControlEventTouchUpInside];
    
    _name_edit.delegate = self;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self checkName:textField.text];
}

-(void)checkName:(NSString *)name{
    if ([NSString isEmptyString:name]) {
        [self.view makeCenterOffsetToast:@"用户名不能为空"];
        return;
    }
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/login/checkisreg" parameters:@{@"account_name":name} success:^(NSURLSessionDataTask *task, id object) {
        if (![object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:@"用户名已存在,请重新输入"];
        }else{
            _isRightName = YES;
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
    [client hcPOST:@"/v1/login/checkisreg" parameters:@{@"mobile":phone} success:^(NSURLSessionDataTask *task, id object) {
        if (![object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:@"手机号已被注册,请重新输入"];
        }else{
            _isRightPhone = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
    }];
}

- (IBAction)registe:(id)sender {
    [self checkName:_name_edit.text];
    if (!_isRightName) {
        return;
    }
    
    [self checkPhone:_phone_edit.text];
    if (!_isRightPhone) {
        return;
    }
    
    if ([NSString isEmptyString:_pass_edit1.text]) {
        [self.view makeCenterOffsetToast:@"密码不能为空"];
        return;
    }
    
    if ([NSString isEmptyString:_pass_edit2.text]) {
        [self.view makeCenterOffsetToast:@"请确认密码"];
        return;
    }
    
    if (![_pass_edit1.text isEqualToString:_pass_edit2.text]) {
        [self.view makeCenterOffsetToast:@"两次密码不一致,请重新输入"];
        return;
    }
    
    if ([NSString isEmptyString:_phone_edit.text]) {
        [self.view makeCenterOffsetToast:@"手机号不能为空"];
        return;
    }
    
    if ([NSString isEmptyString:_code_edit.text]) {
        [self.view makeCenterOffsetToast:@"验证码不能为空"];
        return;
    }
    
    if(!_isChecked){
        [self.view makeCenterOffsetToast:@"请勾选注册条款"];
        return;
    }
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/login/checkregister" parameters:@{@"mobile":_phone_edit.text,@"account_name":_name_edit.text,@"password":_pass_edit1.text,@"repassword":_pass_edit2.text,@"vercode":_code_edit.text} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:@"注册成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
    }];
   
}


-(void)tologin{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)checkChanged{
    if (_isChecked) {
        _isChecked = NO;
        _checkBox.image = [UIImage imageNamed:@"ic_check_normal"];
    }else{
        _isChecked = YES;
        _checkBox.image = [UIImage imageNamed:@"ic_check_checked"];
    }
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

-(void)toRule{
    UserRuleViewController *controller = [[UserRuleViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)hideKey{
    [self.view endEditing:YES];
}

@end
