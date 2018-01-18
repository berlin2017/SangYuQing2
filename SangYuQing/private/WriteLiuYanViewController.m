//
//  WriteLiuYanViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "WriteLiuYanViewController.h"
#import "UserLoginViewController.h"

@interface WriteLiuYanViewController ()<UITextViewDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UITextView *textView;
@end

@implementation WriteLiuYanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKey)];
    [self.view addGestureRecognizer:gesture];
    
    _label= [[UILabel alloc]init];
    [self.view addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.bottom.mas_equalTo(self.view).mas_offset(-20);
    }];
    _label.text = @"剩余300字";
    
    self.textView = [[UITextView alloc]init];

//    _textfild.placeholder = @"请输入留言，留言将由建墓者筛选后显示";
//    _textfild.backgroundColor = [UIColor whiteColor];
//    _textfild.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [_textfild addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
    
    self.textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
    
    self.textView.delegate = self;//设置它的委托方法
    
    self.textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
    
    self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    self.textView.scrollEnabled = YES;//是否可以拖动
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [self.view addSubview: self.textView];//加入到整个页面中
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.top.mas_equalTo(self.navigationView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo([UIScreen mainScreen].bounds.size.height-64-[[UIApplication sharedApplication] statusBarFrame].size.height - 80);
    }];
   
}

-(void)hideKey{
    [self.view endEditing:YES];
}

-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] > 300) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, 300)];
        [textView.undoManager removeAllActions];
        [textView becomeFirstResponder];
        return;
    }
    _label.text = [NSString stringWithFormat:@"剩余%zd",300 - textView.text.length];
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
        title.text = @"写留言";
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
        
        UIButton *right_btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_navigationView addSubview:right_btn];
        [right_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_navigationView).mas_offset(-10);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(50);
        }];
        right_btn.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
        [right_btn setTitle:@"提交" forState:UIControlStateNormal];
        right_btn.tintColor = [UIColor whiteColor];
        [right_btn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        right_btn.layer.cornerRadius = 5;
        right_btn.layer.masksToBounds = YES;
    }
    return _navigationView;
}

-(void)commit{
    if ([NSString isEmptyString:self.textView.text]) {
        [self.view makeCenterOffsetToast:@"内容不能为空"];
        return;
    }
    
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"/v1/liuyan/handle-liuyan-post" parameters:@{@"szid":_sz_id,@"type":@"1",@"showname":@"0",@"content":self.textView.text}  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:@"留言成功"];
            [self.navigationController popViewControllerAnimated:YES];
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

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
