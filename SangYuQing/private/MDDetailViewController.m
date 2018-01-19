//
//  MDDetailViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MDDetailViewController.h"
#import "ButtomBarCollectionViewCell.h"
#import "DetailMenuCollectionViewCell.h"
#import "UILabel+Extension.h"
#import "DetailTabBarViewController.h"
#import "ZhuiSiViewController.h"
#import "GiftView.h"
#import "XianHuaViewController.h"
#import "ShangXiangViewController.h"
#import "JiPinViewController.h"
#import "ZhuangShiViewController.h"
#import "GiftModel.h"
#import "HZHttpClient.h"
#import "MuDiDetailModel.h"
#import "ZhuiSiViewController.h"
#import "DetailXiangCeViewController.h"
#import "DetailVideoViewController.h"
#import "GiftCategoryModel.h"
#import "UserLoginViewController.h"
#import "UserModel.h"
#import "UserManager.h"
#import "DetailGiftModel.h"
#import "JPModel.h"
#import "JiPinManageViewController.h"

@interface MDDetailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,GiftViewDelegate,XianHuaViewControllerDelegate,ShangXiangViewControllerDelegate,ZhuangShiViewControllerDelegate,JiPinViewControllerDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property(nonatomic,strong) UIImageView *right_imageview;
@property(nonatomic,copy)NSMutableArray *names;
@property(nonatomic,copy)NSMutableArray *images;

@property(nonatomic,copy)NSMutableArray *names2;
@property(nonatomic,copy)NSMutableArray *images2;

@property(nonatomic,strong) GiftView *giftView;
@property(nonatomic,assign) BOOL *isLike;

@property(nonatomic,strong)UIView *contentView;

@property(nonatomic,copy)MuDiDetailModel *mDetail;

@property(nonatomic,strong)UIImageView *bg_imageview;
@property(nonatomic,strong)UIImageView *mubei_imageview;
@property(nonatomic,strong)UIImageView *photo;
@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *title_label;
@property(nonatomic,strong)NSArray *gifts;
@property(nonatomic,strong)GiftModel *gitModel;
@property(nonatomic,strong)UserModel *user;
@property(nonatomic,strong)NSArray *giftList;
//@property(nonatomic,strong)UICollectionView *collectionview;
@end

@implementation MDDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    [self requestDetail];
    
    _names = [NSMutableArray arrayWithObjects:@"追思一生",@"相册",@"视频", nil];
    _isLike = NO;
    //    _names = [NSMutableArray arrayWithObjects:@"追思一生",@"相册",@"视频",@"祭品管理", nil];
    _images = [NSMutableArray arrayWithObjects:@"ic_bottom_zhuisi_light",@"ic_bottom_photo_light",@"ic_bottom_video_light",@"ic_bottom_jipin_light", nil];
    
    _names2 = [NSMutableArray arrayWithObjects:@"鲜花",@"上香",@"祭品",@"装饰", nil];
    _images2 = [NSMutableArray arrayWithObjects:@"ic_detail_xianhua",@"ic_detail_shangxiang",@"ic_detail_jipin",@"ic_detail_zhuangshi", nil];
    
    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
//    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)/(_names.count) , tabBarHeight);
//    layout.minimumLineSpacing = 0;
//    layout.minimumInteritemSpacing = 0;
//    
//    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height- tabBarHeight, [UIScreen mainScreen].bounds.size.width, tabBarHeight) collectionViewLayout:layout];
//    [self.view addSubview:_collectionview];
//    _collectionview.tag = 1000;
//    UIImageView *bg = [[UIImageView alloc]init];
//    bg.image = [UIImage imageNamed:@"button_bg"];
//    _collectionview.backgroundView = bg;
//    _collectionview.delegate = self;
//    _collectionview.dataSource = self;
//    [_collectionview registerNib:[UINib nibWithNibName:@"ButtomBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bottom_bar_cell"];
//    
    _contentView = [[UIImageView alloc]init];
    [self.view addSubview:_contentView];
    _contentView.userInteractionEnabled = YES;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
        make.bottom.mas_equalTo(self.view).mas_offset(-tabBarHeight);
    }];
    
    CGFloat height = ([UIScreen mainScreen].bounds.size.height-64-[[UIApplication sharedApplication] statusBarFrame].size.height-tabBarHeight);
    
    _bg_imageview = [[UIImageView alloc]init];
    [_contentView addSubview:_bg_imageview];
    [_bg_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentView);
        make.right.mas_equalTo(_contentView);
        make.top.mas_equalTo(_contentView);
        make.height.mas_equalTo(height/2);
    }];
    [_bg_imageview sd_setImageWithURL:[NSURL URLWithString:@"http://www.hwsyq.com/data/images/background/bg2.jpg"] placeholderImage:nil options:SDWebImageRetryFailed];
    _bg_imageview.contentMode = UIViewContentModeScaleAspectFill;
    _bg_imageview.layer.masksToBounds = YES;
    
    
    _mubei_imageview = [[UIImageView alloc]init];
    [_contentView addSubview:_mubei_imageview];
    [_mubei_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentView);
        make.right.mas_equalTo(_contentView);
        make.bottom.mas_equalTo(_contentView);
        make.height.mas_equalTo(height);
    }];
    [_mubei_imageview sd_setImageWithURL:[NSURL URLWithString:@"http://www.hwsyq.com/data/images/background/01.png"] placeholderImage:nil options:SDWebImageRetryFailed];
    _mubei_imageview.contentMode = UIViewContentModeScaleAspectFill;
    _mubei_imageview.layer.masksToBounds = YES;
    
    
    UICollectionViewFlowLayout *layout2 = [UICollectionViewFlowLayout new];
    layout2.itemSize = CGSizeMake(50, 50);
    layout2.minimumLineSpacing = 10;
    layout2.minimumInteritemSpacing = 10;
    
    UICollectionView *collectionview2 = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout2];
    [self.view addSubview:collectionview2];
    [collectionview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentView).mas_offset(([UIScreen mainScreen].bounds.size.width-230)/2);
        make.right.mas_equalTo(_contentView).mas_offset(-([UIScreen mainScreen].bounds.size.width-230)/2);
        make.bottom.mas_equalTo(self.view).mas_offset(-20-tabBarHeight);
        make.height.mas_equalTo(50);
    }];
    collectionview2.tag = 2000;
    collectionview2.backgroundColor = [UIColor clearColor];
    collectionview2.delegate = self;
    collectionview2.dataSource = self;
    [collectionview2 registerNib:[UINib nibWithNibName:@"DetailMenuCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"detail_menu_cell"];
    
    
    _name = [[UILabel alloc]init];
    [_contentView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view).mas_equalTo(-10);
        make.height.mas_equalTo(65);
    }];
    _name.font = [UIFont systemFontOfSize:13];
    _name.textColor = [UIColor whiteColor];
    
    _photo = [[UIImageView alloc]init];
    [_contentView addSubview:_photo];
    [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_name.mas_top).mas_offset(-5);
        make.centerX.mas_equalTo(_contentView);
        make.height.mas_equalTo(28);
        make.width.mas_equalTo(21);
    }];
    _photo.backgroundColor = [UIColor clearColor];
    //    photo.contentMode = UIViewContentModeScaleAspectFill;
//    [_photo sd_setImageWithURL:[NSURL URLWithString:@"http://www.hwsyq.com/data/images/shizhe/2017091422292149.jpg"]];
    
    [self requestGiftList];
    [self requestGift];
}

-(void)requestGiftList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/jipin-category/get?cpids%5B%5D=1&cpids%5B%5D=2&cpids%5B%5D=3&cpids%5B%5D=4" parameters:nil  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            _gifts = [MTLJSONAdapter modelsOfClass:[GiftCategoryModel class] fromJSONArray:object[@"data"]  error:nil];
            NSLog(@"-----");
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

-(void)requestDetail{
    if (!_sz_id) {
        [self.view makeCenterOffsetToast:@"页面错误,请退出重试"];
        return;
    }
    HZHttpClient *client = [HZHttpClient httpClient];
    [HZLoadingHUD showHUDInView:self.view];
    [client hcGET:@"/v1/gongmu/detail" parameters:@{@"id":_sz_id,} success:^(NSURLSessionDataTask *task, id object) {
        
        if(object[@"state"]){
            NSLog(@"success");
            _mDetail =[MTLJSONAdapter modelOfClass:[MuDiDetailModel class] fromJSONDictionary:object[@"data"][@"CemeteryInfo"] error:nil];
            if (_mDetail.follow==1) {
                _isLike = YES;
                 _right_imageview.image = [UIImage imageNamed:@"ic_like_high"];
            }
            //底部栏
            UserModel *user = [UserManager ahnUser];
            if([_mDetail.user_id integerValue]==user.user_id){
                [_names addObject:@"祭品管理"];
            }
            UITabBarController *tabBarVC = [[UITabBarController alloc] init];
            CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
            UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
            layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width)/(_names.count) , tabBarHeight);
            layout.minimumLineSpacing = 0;
            layout.minimumInteritemSpacing = 0;
            
            UICollectionView* _collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height- tabBarHeight, [UIScreen mainScreen].bounds.size.width, tabBarHeight) collectionViewLayout:layout];
            [self.view addSubview:_collectionview];
            _collectionview.tag = 1000;
            UIImageView *bg = [[UIImageView alloc]init];
            bg.image = [UIImage imageNamed:@"button_bg"];
            _collectionview.backgroundView = bg;
            _collectionview.delegate = self;
            _collectionview.dataSource = self;
            [_collectionview registerNib:[UINib nibWithNibName:@"ButtomBarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"bottom_bar_cell"];
            
            
            [_mubei_imageview sd_setImageWithURL:[NSURL URLWithString:_mDetail.mubei]];
            [_bg_imageview sd_setImageWithURL:[NSURL URLWithString:_mDetail.beijing]];
            [_photo sd_setImageWithURL:[NSURL URLWithString:_mDetail.sz_avatar]];
            _name.verticalText = _mDetail.sz_name;
            _title_label.text = _mDetail.sz_name;
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败，请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1000) {
        return _names.count;
    }
    return _names2.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1000) {
        ButtomBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"bottom_bar_cell" forIndexPath:indexPath];
        [cell configWithName:_names[indexPath.row] image:[UIImage imageNamed:_images[indexPath.row]]];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    else{
        DetailMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detail_menu_cell" forIndexPath:indexPath];
        [cell configWithName:_names2[indexPath.row] image:[UIImage imageNamed:_images2[indexPath.row]]];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView.tag==1000){
        
        
        [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                                            }
                                                 forState:UIControlStateSelected];
        [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                            NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                                            }
                                                 forState:UIControlStateNormal];
        [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, -1);
        
        NSArray *normalImages = @[@"ic_bottom_zhuisi",@"ic_bottom_photo",@"ic_bottom_video",@"ic_bottom_jipin"
                                  ];
        
        NSInteger index = 0;
        NSMutableArray *array =[NSMutableArray new];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UITabBarController *tabBarController = [sb instantiateViewControllerWithIdentifier:@"detail_story"];
       
//        for (int i=0;i< tabBarController.viewControllers.count;i++) {
//            UIViewController * viewController = tabBarController.viewControllers[i];
//            if (i==0) {
//               ZhuiSiViewController *cont =  (ZhuiSiViewController*)viewController;
//                cont.sz_id = _sz_id;
//            }
//            if (i==1) {
//                DetailXiangCeViewController *cont =  (DetailXiangCeViewController*)viewController;
//                cont.sz_id = _sz_id;
//            }
//            if (i==2) {
//                DetailVideoViewController *cont =  (DetailVideoViewController*)viewController;
//                cont.sz_id = _sz_id;
//            }
//            if ([tabBarController.viewControllers lastObject]==viewController&&_names.count==3) {
//                JiPinManageViewController *controller = [[JiPinManageViewController alloc]init];
//
//
//            }else{
//                UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:_names[index]
//                                                                   image:[[UIImage imageNamed:normalImages[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
//                                                           selectedImage:[[UIImage imageNamed:_images[index]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//                viewController.tabBarItem = item;
//                [array addObject:viewController];
//                ++ index;
//            }
//        }
        
        ZhuiSiViewController *cont1 =  [[ZhuiSiViewController alloc]init];
        cont1.sz_id = _sz_id;
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:_names[0] image:[[UIImage imageNamed:normalImages[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:_images[0]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
         cont1.tabBarItem = item;
         [array addObject:cont1];
        
        DetailXiangCeViewController *cont2 =  [[DetailXiangCeViewController alloc]init];
        cont2.sz_id = _sz_id;
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:_names[1] image:[[UIImage imageNamed:normalImages[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:_images[1]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        cont2.tabBarItem = item2;
        [array addObject:cont2];
        
        DetailVideoViewController *cont3 =  [[DetailVideoViewController alloc]init];
        cont3.sz_id = _sz_id;
        UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:_names[2] image:[[UIImage imageNamed:normalImages[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:_images[2]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        cont3.tabBarItem = item3;
         [array addObject:cont3];
        
        JiPinManageViewController *cont4 =  [[JiPinManageViewController alloc]init];
        cont4.sz_id = _sz_id;
        if (_names.count==4) {
            UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:_names[3] image:[[UIImage imageNamed:normalImages[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:_images[3]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            cont4.tabBarItem = item4;
            [array addObject:cont4];
        }
        
       
        [tabBarController setViewControllers:array];
        tabBarController.selectedIndex = indexPath.row;
        [self.navigationController pushViewController:tabBarController animated:YES];
    }else{
        
        
        //跳转到鲜花界面
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UITabBarController *tabBarController = [sb instantiateViewControllerWithIdentifier:@"detail_xianhua"];
//        tabBarController.view.backgroundColor = [UIColor clearColor];

       
        XianHuaViewController *controller = tabBarController.viewControllers[0];
        controller.delegate2 = self;
        GiftCategoryModel *model = _gifts[0];
        controller.list = model.sub_cate;
        
        ShangXiangViewController *controller2 = tabBarController.viewControllers[1];
        controller2.delegate2 = self;
        GiftCategoryModel *model2 = _gifts[1];
        controller2.list = model2.sub_cate;
        
        JiPinViewController *controller3 = tabBarController.viewControllers[2];
        controller3.delegate2 = self;
        GiftCategoryModel *model3 = _gifts[2];
        controller3.list = model3.sub_cate;
        
        ZhuangShiViewController *controller4 = tabBarController.viewControllers[3];
        controller4.delegate2 = self;
        GiftCategoryModel *model4 = _gifts[3];
        controller4.list = model4.sub_cate;
        
        self.definesPresentationContext = YES;
        tabBarController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
        tabBarController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        tabBarController.selectedIndex = indexPath.row;
        [self presentViewController:tabBarController animated:YES completion:nil];
        
        
//        tabBarController.selectedIndex = indexPath.row;
//        [self.navigationController pushViewController:tabBarController animated:NO];
        
    }
}

//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)clickWithModel:(GiftModel*)model{
    _gitModel = model;
    _giftView = [[GiftView alloc]init];
    [_contentView addSubview:_giftView];
    [_giftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(_contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    [_giftView setImage:model.image];
    _giftView.userInteractionEnabled = YES;
    _giftView.delegate = self;
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
        
        _title_label = [[UILabel alloc]init];
        [_navigationView addSubview:_title_label];
        [_title_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_navigationView);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
            make.height.mas_equalTo(30);
        }];
        _title_label.font = [UIFont systemFontOfSize:17];
        _title_label.text = @"详情";
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
        
        _right_imageview = [[UIImageView alloc]init];
        [_navigationView addSubview:_right_imageview];
        [_right_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_navigationView).mas_offset(-10);
            make.bottom.mas_equalTo(_navigationView).mas_offset(-19.5);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(25);
        }];
        _right_imageview.image = [UIImage imageNamed:@"ic_like"];
        _right_imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(likeOrNot)];
        [_right_imageview addGestureRecognizer:tap];
    }
    return _navigationView;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)likeOrNot{
    _isLike = !_isLike;
    NSString *type;
    //网络请求  关注
    if (_isLike) {
        type = @"1";
    }else{
        type = @"0";
    }
    
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/gongmu/follow" parameters:@{@"cemetery_id":_cemetery_id,@"type":type} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
//             [self.view makeCenterOffsetToast:@"成功"];
            if (_isLike) {
                _right_imageview.image = [UIImage imageNamed:@"ic_like_high"];
                
            }else{
                _right_imageview.image = [UIImage imageNamed:@"ic_like"];
            }
             [[NSNotificationCenter defaultCenter] postNotificationName:@"follow.notification" object:nil];
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
}

-(void)confirm{
    if (![UserManager ahnUser]) {
        [self.view makeCenterOffsetToast:@"请登录后继续操作"];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
        UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    }
    _user = [UserManager ahnUser];
    NSString *content;
    if (_user.bonus_point<_gitModel.jifen) {
        content = @"积分不足,请充值后继续";
    }
    content = [NSString stringWithFormat:@"本次敬献需要%zd积分。\n使用用户积分支付,可用积分为:\n%zd",_gitModel.jifen,_user.bonus_point];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:content preferredStyle:UIAlertControllerStyleAlert];
    //以下方法就可以实现在提示框中输入文本；
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (_user.bonus_point<_gitModel.jifen) {
            return ;
        }
        HZHttpClient *client = [HZHttpClient httpClient];
        int x = ceilf(_giftView.frame.origin.x*1.0);
        int y = ceilf(_giftView.frame.origin.y*1.0);
        [client hcPOST:@"/v1/ucenter/handle-jibai" parameters:@{@"jpid":[NSString stringWithFormat:@"%zd",_gitModel.jipin_id],@"sz_id":_sz_id,@"jbtype":@"1",@"posx":[NSString stringWithFormat:@"%zd",x],@"posy":[NSString stringWithFormat:@"%zd",y]} success:^(NSURLSessionDataTask *task, id object) {
            if ([object[@"state_code"] isEqualToString:@"0000"]) {
                [_giftView finishEdit];
                NSLog(@"-----");
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
    }]];
    
    //present出AlertView
    [self presentViewController:alertController animated:true completion:nil];
   
}

-(void)requestGift{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/shizhe/get-jipins" parameters:@{@"sz_id":_sz_id,@"jpx_type":@"1"} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            _giftList = [MTLJSONAdapter modelsOfClass:[DetailGiftModel class] fromJSONArray:object[@"data"] error:nil];
            for (DetailGiftModel*model in _giftList) {
                float screenWith = [UIScreen mainScreen].bounds.size.width;
                float width = [model.posx integerValue]*screenWith/1200;
                float height = [model.posy integerValue]*(_contentView.frame.size.height)/746;
                GiftView *git = [[GiftView alloc]initWithFrame:CGRectMake(width,height, 60, 60)];
                JPModel *info = model.jipinInfo;
                [git setImage:info.image];
                [git finishEdit];
                [self.view addSubview:git];
            }
            NSLog(@"-----");
        }else if([object[@"state_code"] isEqualToString:@"9999"]){
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [self.navigationController pushViewController:viewController animated:YES];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"获取礼物失败,请重试"];
    }];
}

@end
