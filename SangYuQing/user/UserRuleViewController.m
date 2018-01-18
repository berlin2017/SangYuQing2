//
//  UserRuleViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserRuleViewController.h"

@interface UserRuleViewController ()
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@end

@implementation UserRuleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    UIScrollView *scrollview = [[UIScrollView alloc]init];
    [self.view addSubview:scrollview];
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
    }];
    UIView *contentview = [[UIView alloc]init];
    [scrollview addSubview:contentview];
    
    [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(scrollview);
    }];
    
    UILabel *info = [[UILabel alloc]init];
    [contentview addSubview:info];
    info.textColor = [UIColor grayColor];
    info.numberOfLines = 0;//表示label可以多行显示
    info.text = @"    访问者在接受本网站服务之前，请务必仔细阅读本条款并同意本声明。访问者访问本网站的行为以及通过各类方式利用本网站的行为，都将被视作是对本声明全部内容的无异议的认可；如有异议，请立即跟本网站协商，并取得本网站的书面同意意见。\n\n第一条 访问者在从事与本网站相关的所有行为（包括但不限于访问浏览、利用、转载、宣传介绍）时，必须以善意且谨慎的态度行事；访问者不得故意或者过失的损害或者弱化本网站的各类合法权利与利益，不得利用本网站以任何方式直接或者间接的从事违反中国法律、国际公约以及社会公德的行为，且访问者应当恪守下述承诺：\n\n1、传输和利用信息符合中国法律、国际公约的规定、符合公序良俗；\n\n2、不将本网站以及与之相关的网络服务用作非法用途以及非正当用途；\n\n3、不干扰和扰乱本网站以及与之相关的网络服务；\n\n4、遵守与本网站以及与之相关的网络服务的协议、规定、程序和惯例等。\n\n第二条 本网站郑重提醒访问者：请在转载、上载或者下载有关作品时务必尊重该作品的版权、著作权；如果您发现有您未署名的作品，请立即和我们联系，我们会在第一时间加上您的署名或作相关处理。\n\n第三条 除我们另有明确说明或者中国法律有强制性规定外，本网站用户原创的作品，本网站及作者共同享有版权，其他网站及传统媒体如需使用，须取得本网站的书面授权，未经授权严禁转载或用于其它商业用途。\n\n第四条 本网站内容仅代表作者本人的观点，不代表本网站的观点和看法，与本网站立场无关，相关责任作者自负。\n\n第五条 本网站有权将在本网站内发表的作品用于其他用途，包括网站、电子杂志等，作品有附带版权声明者除外。\n\n第六条 未经常本网站和作者共同同意，其他任何机构不得以任何形式侵犯其作品著作权，包括但不限于：擅自复制、链接、非法使用或转载，或以任何方式建立作品镜像。\n\n第七条 本网站所刊载的各类形式（包括但不仅限于文字、图片、图表）的作品仅供参考使用，并不代表本网站同意其说法或描述，仅为提供更多信息，也不构成任何投资建议。对于访问者根据本网站提供的信息所做出的一切行为，除非另有明确的书面承诺文件，否则本网站不承担任何形式的责任。\n\n第八条 当本网站以链接形式推荐其他网站内容时，本网站并不对这些网站或资源的可用性负责，且不保证从这些网站获取的任何内容、产品、服务或其他材料的真实性、合法性，对于任何因使用或信赖从此类网站或资源上获取的内容、产品、服务或其他材料而造成（或声称造成）的任何直接或间接损失，本网站均不承担任何责任。\n\n第九条 访问者在本网站注册时提供的一些个人资料，本网站除您本人同意及第十条规定外不会将用户的任何资料以任何方式泄露给任何一方。\n\n第十条 当政府部门、司法机关等依照法定程序要求本网站披露个人资料时，本网站将根据执法单位之要求或为公共安全之目的提供个人资料。在此情况下之任何披露，本网站均得免责。\n\n第十一条 由于用户将个人密码告知他人或与他人共享注册账户，由此导致的任何个人资料泄露，本网站不负任何责任。\n\n第十二条 本网站有部分内容来自互联网，如无意中侵犯了哪个媒体 、公司 、企业或个人等的知识产权，请来电或致函告之，本网站将在规定时间内给予删除等相关处理，若有涉及版权费等问题，请及时提供相关证明等材料并与我们联系，通过友好协商公平公正原则处理纠纷。\n\n";
    info.font = [UIFont systemFontOfSize:15];
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(scrollview).mas_offset(10);
        make.left.mas_equalTo(scrollview).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
    }];
    
    [contentview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(info.mas_bottom).mas_offset(10);
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
        title.text = @"服务条款";
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
