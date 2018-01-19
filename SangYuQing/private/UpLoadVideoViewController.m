//
//  UpLoadVideoViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/19.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UpLoadVideoViewController.h"
#import "CreatEditTableViewCell.h"
#import "CreatPhotoTableViewCell.h"
#import "CreatCheckBoxTableViewCell.h"
#import "UserLoginViewController.h"
#import "MuDIModel.h"
#import "MMSheetView.h"
#import "CTAssetsPickerController.h"

@interface UpLoadVideoViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,CreatPhotoTableViewCellDelegate,CTAssetsPickerControllerDelegate>

@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic,strong)UITableView *tableview;
@property(nonatomic,copy)NSMutableArray *array;
@property(nonatomic,copy)UIImage *choseImage;
@property(nonatomic,assign)NSInteger cemeteryType;
@property(nonatomic,copy)NSMutableArray * guanxiData;
@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,strong) UIPickerView *pickview;
@property(nonatomic,copy)NSString * choseImageUrl;
@property(nonatomic,assign)BOOL isChecked;
@end

NSMutableArray * _assets;
ALAsset * videoAlasset;

@implementation UpLoadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
    
    _guanxiData = [NSMutableArray new];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
    
    UITapGestureRecognizer *key_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKey)];
    [self.navigationView addGestureRecognizer:key_recognizer];
    
    _array = [NSMutableArray arrayWithObjects:@"视频标题:",@"视频封面:",@"上传视频:", nil];
    _tableview = [[UITableView alloc]init];
    [self.view addSubview:_tableview];
    [_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.userInteractionEnabled = YES;
    _tableview.backgroundColor = [UIColor clearColor];
    [_tableview registerNib:[UINib nibWithNibName:@"CreatEditTableViewCell" bundle:nil] forCellReuseIdentifier:@"creat_edit_cell"];
    [_tableview registerNib:[UINib nibWithNibName:@"CreatPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"creat_photo_cell"];
    [_tableview registerNib:[UINib nibWithNibName:@"CreatCheckBoxTableViewCell" bundle:nil] forCellReuseIdentifier:@"creat_check_cell"];
    _isChecked = YES;
    
}


-(void)updateUserModel{
    //    [self requestAdd];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==1||indexPath.row==2){
        return 140;
    }
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _array.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        CreatEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"creat_edit_cell"];
        cell.name_label.text = _array[indexPath.row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    
    if (indexPath.row==1) {
        CreatPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"creat_photo_cell"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.title_label.text = _array[1];
        return cell;
    }
    
    if (indexPath.row==2) {
        CreatPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"creat_photo_cell"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.title_label.text = _array[2];
        cell.tishi_label.text = @"注:上传的视频应小于500M,且格式需为H264编码的MP4视频。";
        return cell;
    }
    
    return nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.userInteractionEnabled = YES;
    [btn setTitle:@"保存" forState: UIControlStateNormal];
    btn.tintColor = [UIColor whiteColor];
    btn.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    [btn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(160);
        make.center.mas_equalTo(footer);
    }];
    return footer;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    if(indexPath.row==1){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    
    if(indexPath.row==2){
        [self showVideoSelectAction];
    }
}

-(void)showVideoSelectAction{
    NSArray *items = @[
                       MMItemMake(@"本地视频", MMItemTypeNormal, ^(NSInteger index) {
                           CTAssetsPickerController *pickerController = [[CTAssetsPickerController alloc] init];
                           pickerController.delegate = self;
                           pickerController.assetsFilter = [ALAssetsFilter  allVideos];
                           pickerController.showsNumberOfAssets = NO;
                           if (_assets) {
                               pickerController.selectedAssets = [_assets mutableCopy];
                           }
                           pickerController.title = @"选择视频";
                           [self presentViewController:pickerController animated:YES completion:nil];
                       }),
                       
                       MMItemMake(@"视频拍摄", MMItemTypeNormal, ^(NSInteger index) {
                           if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                               UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                               picker.delegate = self;
                               picker.allowsEditing = NO;
                               picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                               picker.modalPresentationStyle = UIModalPresentationFullScreen;
                               picker.mediaTypes = @[(NSString *)kUTTypeMovie];
                               [self presentViewController:picker animated:YES completion:nil];
                           }
                           else {
                               [[[MMAlertView alloc] initWithConfirmTitle:@"温馨提示" detail:@"无法打开相机"] show];
                           }
                       })
                       
                       ];
    [[[MMSheetView alloc] initWithTitle:@"请选择视频" items:items] show];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    _assets = [assets mutableCopy];
    ALAsset * item = _assets[0];
    videoAlasset = item;
    UIImage *image = [UIImage imageWithCGImage:item.thumbnail];
    CreatPhotoTableViewCell *cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.imageview.image = image;
    
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    // Allow 5 assets to be picked
    BOOL should = picker.selectedAssets.count < 1;
    return should;
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
    NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"video" forKey:@"uploaddir"];
    [dict setObject:@"_csrf" forKey:@"_csrf"];
    [manager POST:@"http://jk.hwsyq.com/v1/ucenter/storeimg" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
        [formData appendPartWithFileData:imageData name:@"UploadForm[image]" fileName:@"icon.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据
        if (![responseObject[@"state_code"] isEqualToString:@"8888"]) {
            //            [self.view makeCenterOffsetToast:@"上传成功"];
            _choseImageUrl = responseObject[@"image_name"];
            CreatPhotoTableViewCell *cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.imageview.image = image;
        }else{
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
            [self.navigationController popViewControllerAnimated:YES];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [viewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:viewController animated:YES];
        }
        
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeCenterOffsetToast:@"上传失败,请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
}

-(void)checkedChanged:(BOOL)isChecked{
    _isChecked = isChecked;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    if (isChecked) {
        [_array removeObjectAtIndex:6];
        [_tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [_tableview reloadData];
    }else{
        [_array insertObject:@"设置密码:" atIndex:6];
        [_tableview reloadData];
    }
}

-(void)commit{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    CreatEditTableViewCell *cell = [_tableview cellForRowAtIndexPath:path];
    if([NSString isEmptyString:cell.edittext.text]){
        [self.view makeCenterOffsetToast:@"标题不能为空"];
        return;
    }
    [param setValue:cell.edittext.text forKey:@"video_name"];
    
    if([NSString isEmptyString:_choseImageUrl]){
        [self.view makeCenterOffsetToast:@"请选择封面"];
        return;
    }
    [param setValue:_choseImageUrl forKey:@"fm"];
    [param setValue:_sz_id forKey:@"sz_id"];
    [HZLoadingHUD showHUDInView:self.view];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:nil];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
        [manager POST:@"http://jk.hwsyq.com/v1/shipin/savevideo" parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            Byte *buffer = (Byte*)malloc(videoAlasset.defaultRepresentation.size);
            // add error checking here
            NSUInteger buffered = [videoAlasset.defaultRepresentation getBytes:buffer fromOffset:0.0 length:videoAlasset.defaultRepresentation.size error:nil];
            NSData *sourceData = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
            //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
            [formData appendPartWithFileData:sourceData name:@"video" fileName:videoAlasset.defaultRepresentation.filename mimeType:@"video/mpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据
            if ([responseObject[@"state_code"] isEqualToString:@"0000"]) {
                [self.view makeCenterOffsetToast:@"上传成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadvideo.notification" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeCenterOffsetToast:responseObject[@"msg"]];
            }
            
            [HZLoadingHUD hideHUDInView:self.view];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.view makeCenterOffsetToast:@"上传失败,请重试"];
            [HZLoadingHUD hideHUDInView:self.view];
        }];
        
    });
    
}

-(void)hideKey{
    [self.view endEditing:YES];
}

// 自定义导航栏
-(UIView *)navigationView{
    
    if(_navigationView == nil){
        _navigationView = [[UIView alloc]init];
        _navigationView.userInteractionEnabled = YES;
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
        title.text = @"上传视频";
        
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
