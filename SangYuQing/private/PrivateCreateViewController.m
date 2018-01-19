//
//  PrivateCreateViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/2.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PrivateCreateViewController.h"
#import "CreatEditTableViewCell.h"
#import "CreatPhotoTableViewCell.h"
#import "CreatCheckBoxTableViewCell.h"
#import "UserLoginViewController.h"
#import "MuDIModel.h"

@interface PrivateCreateViewController ()<UITableViewDelegate,UITableViewDataSource,CreatCheckBoxTableViewCellDelegate,UIImagePickerControllerDelegate,CreatPhotoTableViewCellDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

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
@property(nonatomic,strong) MuDIModel *detail;
@end

@implementation PrivateCreateViewController

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
    
    _array = [NSMutableArray arrayWithObjects:@"逝者姓名:",@"生辰日期:",@"忌辰日期:",@"情感关系:",@"上传照片:",@"是否公开:", nil];
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
    [self requestAdd];
    _isChecked = YES;
    if (_model) {
        _detail = _model;
        if (![NSString isEmptyString:_model.pass]) {
            _isChecked = NO;
            [_array insertObject:@"设置密码:" atIndex:6];
            [_tableview reloadData];
        }
    }
    if (!_detail) {
        _detail = [[MuDIModel alloc]init];
    }
}

-(void)requestAdd{
    HZHttpClient *client = [HZHttpClient httpClient];
    [client hcGET:@"/v1/cemetery/add" parameters:nil success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"9999"]) {
            [self.view makeCenterOffsetToast:@"登陆信息已过期,请重新登陆"];
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"user" bundle:nil];
            UserLoginViewController * viewController = [sb instantiateViewControllerWithIdentifier:@"user_login"];
            [self.navigationController pushViewController:viewController animated:YES];
        }else if([object[@"state_code"] isEqualToString:@"0000"]){
            NSLog(@"success");
            _cemeteryType = [object[@"data"][@"cemeteryType"] integerValue];
            _guanxiData = object[@"data"][@"guanxiData"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请退出重试"];
    }];
}

-(void)updateUserModel{
    [self requestAdd];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==4){
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
    if (indexPath.row==4) {
        CreatPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"creat_photo_cell"];
        cell.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        if (_detail) {
            if (_detail.sz_avatar_url) {
                [cell.imageview sd_setImageWithURL:[NSURL URLWithString:_detail.sz_avatar_url] placeholderImage:[UIImage imageNamed:@"ic_add"]];
            }else{
                [cell.imageview sd_setImageWithURL:[NSURL URLWithString:_detail.sz_avatar] placeholderImage:[UIImage imageNamed:@"ic_add"]];
            }
             _choseImageUrl = _detail.sz_avatar;
        }
        return cell;
    }
    if (indexPath.row==5) {
        CreatCheckBoxTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"creat_check_cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        [cell.checkBox setOn:_isChecked];
        return cell;
    }
    CreatEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"creat_edit_cell"];
    if (indexPath.row==1||indexPath.row==2) {
        //        cell.edittext.enabled = NO;
        cell.edittext.delegate = self;
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        //设置本地语言
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        //设置日期显示的格式
        datePicker.datePickerMode = UIDatePickerModeDate;
        //设置_birthdayField的inputView控件为datePicker
        cell.edittext.inputView = datePicker;
        _datePicker = datePicker;
        cell.edittext.tag = indexPath.row;
        cell.edittext.returnKeyType = UIReturnKeyDone;
        cell.edittext.delegate = self;
        //监听datePicker的ValueChanged事件
        [datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    }
    if (indexPath.row==0) {
        if (_detail&&_detail.sz_name) {
             cell.edittext.text = _detail.sz_name;
        }
    }
    
    if (indexPath.row==1) {
        cell.edittext.text = _detail.birthdate;
    }
    if (indexPath.row==2) {
        cell.edittext.text = _detail.deathdate;
    }
    if (indexPath.row==3) {
        cell.edittext.text = _detail.relation;
    }
    
    if (indexPath.row==6) {
        cell.edittext.text = _detail.pass;
    }
    
    if (indexPath.row==3) {
        UIPickerView *pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
        cell.edittext.inputView = pickView;
        _pickview = pickView;
        _pickview.delegate = self;
        _pickview.dataSource = self;
    }
    cell.name_label.text = _array[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)valueChange:(UIDatePicker *)datePicker{
    //创建一个日期格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    //设置日期的显示格式
    fmt.dateFormat = @"yyyy-MM-dd";
    //将日期转为指定格式显示
    NSString *dateStr = [fmt stringFromDate:datePicker.date];
    //不知道为啥有问题
    if (datePicker.tag==0) {
        datePicker.tag = 1;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:datePicker.tag inSection:0];
    CreatEditTableViewCell *cell = [_tableview cellForRowAtIndexPath:path];
    cell.edittext.text = dateStr;
    if(datePicker.tag==1){
         _detail.birthdate = dateStr;
    }else{
        _detail.deathdate = dateStr;
    }
   
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag==0){
        _detail.sz_name = textField.text;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag!=0){
        _datePicker.tag = textField.tag;
        //确保加载时也能获取datePicker的文字
        [self valueChange:_datePicker];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    return YES;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footer = [[UIView alloc]init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.userInteractionEnabled = YES;
    [btn setTitle:@"创建墓园" forState: UIControlStateNormal];
    if (_model) {
        [btn setTitle:@"修改墓园" forState: UIControlStateNormal];
    }
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
    
    if(indexPath.row==3){
        
    }
    
    if(indexPath.row==4){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}


#pragma mark - <UIPickerViewDataSource>
//返回几行
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..返回第component列第row行的个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _guanxiData.count;
}

#pragma mark - <UIPickerViewDelegate>
//返回文字数据
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _guanxiData[row];
}
//判断选择的某一列,显示对应的文字数据到label
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSIndexPath *path = [NSIndexPath indexPathForRow:3 inSection:0];
    CreatEditTableViewCell *cell = [_tableview cellForRowAtIndexPath:path];
    cell.edittext.text = _guanxiData[row];
    _detail.relation = _guanxiData[row];
}

-(void)choseImage{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
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
    [dict setObject:@"shizhe" forKey:@"uploaddir"];
    [dict setObject:@"_csrf" forKey:@"_csrf"];
    [manager POST:@"http://jk.hwsyq.com/v1/ucenter/storeimg" parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
        [formData appendPartWithFileData:imageData name:@"UploadForm[image]" fileName:@"icon.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据
        if (![responseObject[@"state_code"] isEqualToString:@"8888"]) {
            //            [self.view makeCenterOffsetToast:@"上传成功"];
            _choseImageUrl = responseObject[@"image_name"];
            _detail.sz_avatar = responseObject[@"image_name"];
            _detail.sz_avatar_url = responseObject[@"image_src"];
            CreatPhotoTableViewCell *cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
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
        [self.view makeCenterOffsetToast:@"姓名不能为空"];
        return;
    }
    [param setValue:cell.edittext.text forKey:@"sz_name"];
    
    NSIndexPath *path2 = [NSIndexPath indexPathForRow:1 inSection:0];
    CreatEditTableViewCell *cell2 = [_tableview cellForRowAtIndexPath:path2];
    if([NSString isEmptyString:cell2.edittext.text]){
        [self.view makeCenterOffsetToast:@"请选择生辰日期"];
        return;
    }
    
    [param setValue:cell2.edittext.text forKey:@"birthdate"];
    
    NSIndexPath *path3 = [NSIndexPath indexPathForRow:2 inSection:0];
    CreatEditTableViewCell *cell3 = [_tableview cellForRowAtIndexPath:path3];
    if([NSString isEmptyString:cell3.edittext.text]){
        [self.view makeCenterOffsetToast:@"请选择忌辰日期"];
        return;
    }
    [param setValue:cell3.edittext.text forKey:@"deathdate"];
    
    NSIndexPath *path4 = [NSIndexPath indexPathForRow:3 inSection:0];
    CreatEditTableViewCell *cell4 = [_tableview cellForRowAtIndexPath:path4];
    if([NSString isEmptyString:cell4.edittext.text]){
        [self.view makeCenterOffsetToast:@"请选择情感关系"];
        return;
    }
    [param setValue:cell4.edittext.text forKey:@"relation"];
    
    if (!_isChecked) {
        NSIndexPath *path6 = [NSIndexPath indexPathForRow:6 inSection:0];
        CreatEditTableViewCell *cell6 = [_tableview cellForRowAtIndexPath:path6];
        if([NSString isEmptyString:cell6.edittext.text]){
            [self.view makeCenterOffsetToast:@"密码不能为空"];
            return;
        }else{
            [param setValue:cell6.edittext.text forKey:@"pass"];
        }
    }else{
        [param setValue:@"" forKey:@"pass"];
    }
    
    if (_choseImageUrl) {
        [param setValue:_choseImageUrl forKey:@"sz_avatar"];
    }
    
    [param setValue:[NSString stringWithFormat:@"%zd",_cemeteryType] forKey:@"type"];
    [HZLoadingHUD showHUDInView:self.view];
    HZHttpClient *client = [HZHttpClient httpClient];
    NSString *url =@"/v1/cemetery/add";
    if (_model) {
        [param setValue:_model.cemetery_id forKey:@"cemetery_id"];
        url = @"/v1/cemetery/edit";
    }
    [client hcPOST:url parameters:param  success:^(NSURLSessionDataTask *task, id object) {
        if ([object[@"state_code"] isEqualToString:@"0000"]) {
            [self.view makeCenterOffsetToast:@"成功"];
            [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:2.0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"creat.notification" object:nil];
        }else{
            [self.view makeCenterOffsetToast:object[@"msg"]];
        }
        [HZLoadingHUD hideHUDInView:self.view];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.view makeCenterOffsetToast:@"请求失败,请重试"];
        [HZLoadingHUD hideHUDInView:self.view];
    }];
    
}

-(void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
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
        title.text = @"快速建墓";
        
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
        
        //        UILabel *right_label = [[UILabel alloc]init];
        //        right_label.userInteractionEnabled = YES;
        //        [_navigationView addSubview:right_label];
        //        [right_label mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.mas_equalTo(title);
        //            make.right.mas_equalTo(_navigationView).mas_offset(-10);;
        //        }];
        //        right_label.font = [UIFont systemFontOfSize:14];
        //        right_label.text = @"快速建墓";
        //        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onclickRightMenu)];
        //        [right_label addGestureRecognizer:gesture];
    }
    return _navigationView;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

