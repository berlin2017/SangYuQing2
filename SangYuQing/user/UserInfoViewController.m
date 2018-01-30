//
//  UserInfoViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UserInfoTableViewCell.h"
#import "UserInfoListCell.h"
#import "UIColor+Helper.h"
#import "AddressPickerView.h"
#import "UserLoginViewController.h"
#import "MMSheetView.h"
#import "MMPopupItem.h"
#import "UserModel.h"
#import "UserManager.h"
#import "MyAddressPickView.h"
#import "CityModel.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,MyAddressPickViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UIView *navigationView;       // 导航栏
@property (nonatomic,strong) UIImageView *scaleImageView; // 顶部图片
@property (nonatomic ,strong) MyAddressPickView * pickerView;
@property (nonatomic ,strong) NSString * location_string;
@property (nonatomic ,strong) UITableView * tableview;
@property (nonatomic ,strong) UIImage* photo;
@property (nonatomic ,strong) UserModel* user;
@property (nonatomic ,strong) NSArray* provinceList;
@property (nonatomic ,strong) NSArray* cityList;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"main_bg"]];
    [self.view setBackgroundColor:bgColor];
    [self.view addSubview:self.navigationView];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserModel) name:kZANUserLoginSuccessNotification object:nil];
    
    
    _user = [UserManager ahnUser];
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
    [_tableview registerNib:[UINib nibWithNibName:@"UserInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"userinfo_header"];
    [_tableview registerNib:[UINib nibWithNibName:@"UserInfoListCell" bundle:nil] forCellReuseIdentifier:@"userinfo_cell"];
    [self.view addSubview:self.pickerView];
}


- (MyAddressPickView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[MyAddressPickView alloc]init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
    }
    return _pickerView;
}


-(void)updateUserModel{
    _user = [UserManager ahnUser];
    
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"v1/login/userinfo" parameters:@{@"user_id":[NSString stringWithFormat:@"%zd",_user.user_id]} success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] integerValue] == 0000) {
             _user = [MTLJSONAdapter modelOfClass:[UserModel class] fromJSONDictionary:object[@"data"] error:nil];
            [UserManager saveAhnUser:_user];
            [_tableview reloadData];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
}

#pragma mark - AddressPickerViewDelegate
- (void)cancelBtnClick{
    [self.pickerView hide];
    
}
- (void)sureBtnClickReturnProvince:(CityModel *)province City:(CityModel *)city{
    [self.pickerView hide];
    _location_string = [NSString stringWithFormat:@"%@%@",province.name,city.name];
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"v1/ucenter/updateself" parameters:@{@"household_city_id":city.city_id,@"household_province_id":province.city_id} success:^(NSURLSessionDataTask *task, id object) {
        if (object[@"state"]) {
            [self.view makeCenterOffsetToast:@"修改信息成功"];
            _user.household_city_id = [city.city_id integerValue];
            _user.household_province_id = [province.city_id integerValue];
            _user.household_address = [NSString stringWithFormat:@"%@%@",province.name,city.name];
            [UserManager saveAhnUser:_user];
            [_tableview reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kZANUserLoginSuccessNotification object:nil];
        }else{
            [self.view makeCenterOffsetToast:@"修改信息失败,请重试"];
        }
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"修改信息失败,请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
}



-(NSArray*)proviceList{
    return _provinceList;
}

-(NSArray*)cityList{
    return _cityList;
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
        title.text = @"个人信息";
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 5;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0 ) {
        UserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfo_header"];
        cell .backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
        if (_photo) {
            [cell setPhotoWithImage:_photo];
        }else{
            if (_user&&_user.head_logo) {
                [cell setPhotoWithUrl:_user.head_logo];
            }else{
                [cell setPhotoWithImage:[UIImage imageNamed:@"ic_user"]];
            }
            
        }
        return cell;
    }
    
    UserInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userinfo_cell"];
    cell.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    switch (indexPath.row) {
        case 0:
            if (_user&&_user.account_name) {
                [cell configWithName:@"用户名" value:_user.account_name];
            }else{
                [cell configWithName:@"用户名" value:@""];
            }
            
            [cell hideRight];
            break;
        case 1:
            if (_user&&_user.nickname) {
               [cell configWithName:@"昵称" value:_user.nickname];
            }else{
                [cell configWithName:@"昵称" value:@""];
            }
            
            break;
        case 2:
            if (_user) {
                if (_user.sex==0) {
                    [cell configWithName:@"性别" value:@"男"];
                }else{
                    [cell configWithName:@"性别" value:@"女"];
                }
            }else{
                [cell configWithName:@"性别" value:@"男"];
            }
            break;
        case 3:
            if (_user&&_user.mobile) {
                 [cell configWithName:@"手机" value:_user.mobile];
            }else{
                 [cell configWithName:@"手机" value:@""];
            }
           
            break;
        case 4:
            if (_user&&_user.household_address) {
                 [cell configWithName:@"籍贯" value:_user.household_address];
            }else{
                 [cell configWithName:@"籍贯" value:@""];
            }
           
            break;
            
        default:
            break;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 10;
    }
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
    if (indexPath.section== 0 ) {
        
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
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改昵称" message:@"请输入昵称" preferredStyle:UIAlertControllerStyleAlert];
            //以下方法就可以实现在提示框中输入文本；
            
            //在AlertView中添加一个输入框
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
                textField.placeholder = @"请输入昵称";
            }];
            
            //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
                
                //输出 检查是否正确无误
                NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
                if ([NSString isEmptyString:envirnmentNameTextField.text]) {
                    [self.view makeCenterOffsetToast:@"昵称不能为空"];
                     return ;
                }
                
                [self change:@"nickname" value:envirnmentNameTextField.text];
                
            }]];
            
            //添加一个取消按钮
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            
            //present出AlertView
            [self presentViewController:alertController animated:true completion:nil];
            break;
        }
        case 2:{
            UIAlertController * sheet = [UIAlertController alertControllerWithTitle:nil message:@"选择性别" preferredStyle:UIAlertControllerStyleActionSheet];
            
            [sheet addAction:[UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                
                NSLog(@"在这里处理选择之后的事");
                
                [self change:@"sex" value:@"0"];
            }]];
            
            [sheet addAction:[UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                
                NSLog(@"在这里处理选择之后的事");
                [self change:@"sex" value:@"1"];
            }]];
            
            [sheet addAction:[UIAlertAction actionWithTitle:@"取消"style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:sheet animated:YES completion:nil];
            break;
        }
        case 3:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改手机号码" message:@"请输入手机号码" preferredStyle:UIAlertControllerStyleAlert];
            //以下方法就可以实现在提示框中输入文本；
            
            //在AlertView中添加一个输入框
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                
                textField.placeholder = @"请输入手机号码";
            }];
            
            //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
                
                //输出 检查是否正确无误
                NSLog(@"你输入的文本%@",envirnmentNameTextField.text);
                if ([NSString isEmptyString:envirnmentNameTextField.text]) {
                    [self.view makeCenterOffsetToast:@"手机号不能为空"];
                    return ;
                }
                
                [self change:@"mobile" value:envirnmentNameTextField.text];
                
            }]];
            
            //添加一个取消按钮
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            
            //present出AlertView
            [self presentViewController:alertController animated:true completion:nil];
            break;
        }
        case 4:
            [_pickerView show];
            break;
            
        default:
            break;
    }
}

#pragma mark 调用系统相册及拍照功能实现方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [HZLoadingHUD showHUDInView:self.view];
    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];
    UIImageView * picImageView = (UIImageView *)[self.view viewWithTag:500];
    picImageView.image = chosenImage;
    chosenImage = [self imageWithImageSimple:chosenImage scaledToSize:CGSizeMake(60, 60)];
    //    NSData * imageData = UIImageJPEGRepresentation(chosenImage, 0.9);
    _photo = chosenImage;
    [self upload:_photo];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)upload:(UIImage *)image{
     NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
    [dict setObject:@"user" forKey:@"uploaddir"];
    [dict setObject:@"_csrf" forKey:@"_csrf"];
    [manager POST:@"http://jk.hwsyq.com/v1/ucenter/storeimg" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
        [formData appendPartWithFileData:imageData name:@"UploadForm[image]" fileName:@"icon.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据
        if (![responseObject[@"state_code"] isEqualToString:@"8888"]) {
            [self.view makeCenterOffsetToast:@"上传成功"];
            [self change:@"head_logo" value:responseObject[@"image_src"]];
        }else{
            [self.view makeCenterOffsetToast:@"登录信息已过期，请重新登录"];
//            [UserManager clearAllUser];
//             [[NSNotificationCenter defaultCenter] postNotificationName:kZANUserLoginSuccessNotification object:nil];
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

//-(void)viewWillAppear:(BOOL)animated{
//    if (_tableview) {
//        _user = [UserManager ahnUser];
//        [_tableview reloadData];
//    }
//}

-(void)change:(NSString*)name value:(NSString*)value{
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcPOST:@"v1/ucenter/updateself" parameters:@{name:value} success:^(NSURLSessionDataTask *task, id object) {
        if (object[@"state"]) {
            [self.view makeCenterOffsetToast:@"修改信息成功"];
            if ([name isEqualToString:@"head_logo"]) {
                _user.head_logo = value;
            }
            if ([name isEqualToString:@"nickname"]) {
                _user.nickname = value;
            }
            
            if ([name isEqualToString:@"mobile"]) {
                _user.mobile = value;
            }
            if ([name isEqualToString:@"sex"]) {
                _user.sex = 1;
            }
            [UserManager saveAhnUser:_user];
            [_tableview reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kZANUserLoginSuccessNotification object:nil];
        }else{
            [self.view makeCenterOffsetToast:@"修改信息失败,请重试"];
        }
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"修改信息失败,请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
}

//用户取消选取时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//压缩图片
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

@end
