//
//  XiangCeListViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "XiangCeListViewController.h"
#import "SZDetailModel.h"
#import "XiangCeCollectionTableViewCell.h"
#import "PhotoItem.h"
#import "XiangCeCollectionViewCell.h"
#import "ZANImageShowViewController.h"
#import "UserLoginViewController.h"
#import "TJZPCollectionViewCell.h"
#import "MMSheetView.h"
#import "HUPhotoBrowser.h"
#import "UIImageView+HUWebImage.h"

@interface XiangCeListViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,HZImageShowViewControllerDelegate,HZImageShowViewControllerDataSource,XiangCeCollectionViewCellDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong) NSMutableArray *list;
@property(nonatomic,strong)UICollectionView* collectionview;
@property(nonatomic,strong)NSString* choseImageUrl;
@property(nonatomic,strong)UIButton *cancel;
@property(nonatomic,strong)UIButton *del;
@property (nonatomic, strong) NSMutableArray *URLStrings;
@end

@implementation XiangCeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
    _list = [NSMutableArray new];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width-20)/3, ([UIScreen mainScreen].bounds.size.width-20)/3+30);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    _collectionview = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:_collectionview];
    [_collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
    _collectionview.delegate = self;
    _collectionview.dataSource = self;
    _collectionview.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    [_collectionview registerNib:[UINib nibWithNibName:@"XiangCeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"xiangce_cell"];
    [_collectionview registerNib:[UINib nibWithNibName:@"TJZPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"zpsc_cell"];
    [self requestList];
}

-(void)updateUserModel{
    [self requestList];
}

-(void)requestList{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/gongmu/album" parameters:@{@"id":_sz_id,@"xcid":[NSString stringWithFormat:@"%zd",_xcid]}  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            NSArray* list = [MTLJSONAdapter modelsOfClass:[PhotoItem class] fromJSONArray:object[@"data"][@"CemeteryInfo"][@"album"]  error:nil];
            [_list removeAllObjects];
            [_list addObjectsFromArray:list];
            [_collectionview reloadData];
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

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_type==1) {
        return _list.count+1;
    }
    return _list.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type==1&&indexPath.row==_list.count) {
        TJZPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"zpsc_cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    PhotoItem *model1 = _list[indexPath.row];
    XiangCeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xiangce_cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell configWithModel:model1 atIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type==1&&indexPath.row==_list.count) {
        MMPopupItem *albumItem = MMItemMake(@"打开相册", MMItemTypeNormal, ^(NSInteger index) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        });
        MMPopupItem *cameraItem = MMItemMake(@"打开相机", MMItemTypeNormal, ^(NSInteger index) {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = YES;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else {
                [[[MMAlertView alloc] initWithConfirmTitle:@"温馨提示" detail:@"无法打开相机"] show];
            }
        });
        MMSheetView *sheet = [[MMSheetView alloc] initWithTitle:@"选择头像" items:@[albumItem, cameraItem]];
        [sheet show];
        return;
    }
    _URLStrings = [NSMutableArray new];
    for (PhotoItem*item in _list) {
        [_URLStrings addObject:item.image];
    }
    XiangCeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"xiangce_cell" forIndexPath:indexPath];
    [HUPhotoBrowser showFromImageView:cell.xiangce_imageview withURLStrings:_URLStrings atIndex:indexPath.row];
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    ZANImageShowViewController *controller = [sb instantiateViewControllerWithIdentifier:@"kVcIdfImageShow"];
//    controller.dataSource = self;
//    controller.currentIndex = indexPath.row;
//    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
- (NSInteger)numberOfImages:(ZANImageShowViewController *)imageShowViewController
{
    return _list.count;
}

- (NSURL *)imageShowViewController:(ZANImageShowViewController *)imageShowViewController imageURLAtIndex:(NSInteger)index
{
    if (index < _list.count) {
        PhotoItem *model = _list[index];
        return [NSURL URLWithString:model.image];
    }
    return nil;
}

- (NSString *)imageShowViewController:(ZANImageShowViewController *)imageShowViewController imageTextAtIndex:(NSInteger)index
{
    return nil;
}


#pragma mark 调用系统相册及拍照功能实现方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];
    [self upload:chosenImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)upload:(UIImage *)image{
    [HZLoadingHUD showHUDInView:self.view];
    NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"xiangce" forKey:@"uploaddir"];
    [dict setObject:@"_csrf" forKey:@"_csrf"];
    [dict setObject:[NSString stringWithFormat:@"%zd",_xcid] forKey:@"xid"];
    [dict setObject:@"icon.jpg" forKey:@"name"];
    [manager POST:@"http://jk.hwsyq.com/v1/xiangce/handle-image-post" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
        [formData appendPartWithFileData:imageData name:@"UploadForm[image]" fileName:@"icon.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据
        if (![responseObject[@"state_code"] isEqualToString:@"8888"]) {
            [self.view makeCenterOffsetToast:@"上传成功,请审核"];
            _choseImageUrl = responseObject[@"image_name"];
        }else{
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            [self.navigationController popViewControllerAnimated:YES];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
             [HZLoadingHUD hideHUDInView:self.view];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeCenterOffsetToast:@"上传失败,请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
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
        title.text = @"相册列表";
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
        if (_type==1) {
            UILabel *right_title = [[UILabel alloc]init];
            [_navigationView addSubview:right_title];
            [right_title mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_navigationView).mas_offset(-10);
                make.bottom.mas_equalTo(_navigationView).mas_offset(-17);
                make.height.mas_equalTo(30);
            }];
            right_title.font = [UIFont systemFontOfSize:14];
            right_title.text = @"编辑";
            right_title.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(edit)];
            [right_title addGestureRecognizer:tap];
        }
        
    }
    return _navigationView;
}

-(void)edit{
    _cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancel.backgroundColor = [UIColor clearColor];
    [_cancel setTitle:@"取消" forState:UIControlStateNormal];
    [self.view addSubview:_cancel];
     _cancel.tintColor = [UIColor blackColor];
    _cancel.layer.borderWidth = 1;
    _cancel.layer.borderColor = [UIColor blackColor].CGColor;
    _cancel.layer.cornerRadius = 5;
    _cancel.layer.masksToBounds = YES;
    [_cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-15);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-30)/2);
    }];
    [_cancel addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
    
    _del = [UIButton buttonWithType:UIButtonTypeSystem];
    _del.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
    [_del setTitle:@"删除" forState:UIControlStateNormal];
    _del.tintColor = [UIColor whiteColor];
    _del.layer.borderWidth = 1;
    _del.layer.borderColor = [UIColor colorWithHexString:@"CD853F"].CGColor;
    _del.layer.cornerRadius = 5;
    _del.layer.masksToBounds = YES;
    [self.view addSubview:_del];
    [_del mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-15);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-10);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width-30)/2);
    }];
    [_del addTarget:self action:@selector(delModel) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableArray *array = [NSMutableArray new];
    for (PhotoItem*item in _list) {
        item.canEdit = YES;
        [array addObject:item];
    }
    [_list removeAllObjects];
    [_list addObjectsFromArray:array];
    [_collectionview reloadData];
}

-(void)delModel{
    NSString *s= @"";
    for (PhotoItem*item in _list) {
        if (item.isSelected) {
            s= [s stringByAppendingString: item.szxcp_id];
            s= [s stringByAppendingString: @","];
        }
    }
    if ([NSString isEmptyString:s]) {
        [self.view makeCenterOffsetToast:@"请选择要删除的照片"];
    }else{
        HZHttpClient *client = [HZHttpClient httpClient];
        [client hcPOST:@"/v1/xiangce/delpic" parameters:@{@"id":s}  success:^(NSURLSessionDataTask *task, id object) {
            if ([object[@"state_code"] isEqualToString:@"0000"]) {
                [self cancelEdit];
                [self requestList];
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
}

-(void)cancelEdit{
    [_cancel removeFromSuperview];
    [_del removeFromSuperview];
    NSMutableArray *array = [NSMutableArray new];
    for (PhotoItem*item in _list) {
        item.canEdit = NO;
        [array addObject:item];
    }
    [_list removeAllObjects];
    [_list addObjectsFromArray:array];
    [_collectionview reloadData];
}

-(void)setSelectedAtIndex:(NSInteger)index{
    
    NSMutableArray *array = [NSMutableArray new];
    for (PhotoItem*item in _list) {
        if ([_list indexOfObject:item]==index) {
            item.isSelected = !item.isSelected;
        }
        [array addObject:item];
    }
    [_list removeAllObjects];
    [_list addObjectsFromArray:array];
    [_collectionview reloadData];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
