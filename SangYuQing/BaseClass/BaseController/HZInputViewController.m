//
//  HZInputViewController.m
//  AnhuiNews
//
//  Created by History on 15/3/10.
//  Copyright (c) 2015年 ahxmt. All rights reserved.
//

#import "HZInputViewController.h"

NSString * const kHZPlainTextPlaceholderKey     = @"com.ahn.plain.text.placeholder";
NSString * const kHZSecureTextPlaceholderKey    = @"com.ahn.secure.text.placeholder";

@interface HZInputViewController ()
{
    __weak IBOutlet UITextField *_secondTextField;
    __weak IBOutlet UITextField *_firstTextField;
    __weak IBOutlet UITextView *_textView;
}
@property (strong, nonatomic) NSDictionary *placeholderDictionary;

@end

@implementation HZInputViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _inputMode = HZInputModePlainTextInput;
        _regexMode = HZRegexModeNone;
        [self setup];
    }
    return self;
}

- (void)setup
{
    switch (_inputMode) {
        case HZInputModePlainTextInput: {
            if (_placeholderDictionary) {
                _firstTextField.placeholder = _placeholderDictionary[kHZPlainTextPlaceholderKey];
            }
            _firstTextField.hidden = NO;
            _secondTextField.hidden = YES;
            _textView.hidden = YES;
            _firstTextField.text = _previewText;
            [_firstTextField becomeFirstResponder];
            if (HZRegexModePhone == _regexMode) {
                _firstTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
            break;
        case HZInputModeMultiLineTextInput: {
            _firstTextField.hidden = YES;
            _secondTextField.hidden = YES;
            _textView.hidden = NO;
            _textView.text = _previewText;
            [_textView becomeFirstResponder];
        }
            break;
        case HZInputModeSecureTextInput: {
            if (_placeholderDictionary) {
                _firstTextField.placeholder = _placeholderDictionary[kHZSecureTextPlaceholderKey];
            }
            _firstTextField.hidden = NO;
            _firstTextField.secureTextEntry = YES;
            _secondTextField.hidden = YES;
            _textView.hidden = YES;
            [_firstTextField becomeFirstResponder];
        }
            break;
        case HZInputModeLoginAndPasswordInput: {
            if (_placeholderDictionary) {
                _firstTextField.placeholder = _placeholderDictionary[kHZPlainTextPlaceholderKey];
                _secondTextField.placeholder = _placeholderDictionary[kHZSecureTextPlaceholderKey];
            }
            _firstTextField.hidden = NO;
            _secondTextField.secureTextEntry = YES;
            _secondTextField.hidden = NO;
            _textView.hidden = YES;
            [_firstTextField becomeFirstResponder];
            _firstTextField.keyboardType = UIKeyboardTypeASCIICapable;
        }
            break;
            
        default:
            break;
    }
}

- (void)setFirstKeyboardType:(UIKeyboardType)firstKeyboardType
{
    _firstTextField.keyboardType = firstKeyboardType;
}

- (void)setSecondKeyboardType:(UIKeyboardType)secondKeyboardType
{
    _secondTextField.keyboardType = secondKeyboardType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishInputAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [_textView setLayerBorderWidth:1.f borderColor:[UIColor lightGrayColor] cornerRadius:5.f];
    
    [self setup];
}

- (void)setInputMode:(HZInputMode)inputMode
{
    if (_inputMode != inputMode) {
        _inputMode = inputMode;
        [self setup];
    }
}

- (void)setRegexMode:(HZRegexMode)regexMode
{
    if (_regexMode != regexMode) {
        _regexMode = regexMode;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)validateInputText
{
    switch (_regexMode) {
        case HZRegexModeNone: {
            return YES;
        }
        case HZRegexModePhone: {
            if (![_firstTextField.text isValidPhoneNumber]) {
                [self.view makeCenterOffsetToast:@"请输入正确的手机号"];
                return NO;
            }
            return YES;
        }
        case HZRegexModePwd: {
            if (![_firstTextField.text isValidPassword]) {
                [self.view makeCenterOffsetToast:@"请输入合法的密码"];
                return NO;
            }
            return YES;
        }
            break;
        case HZRegexModeNameAndPwd: {
            if (![_firstTextField.text isValidUserName]) {
                [self.view makeCenterOffsetToast:@"请输入合法的登录名"];
                return NO;
            }
            if (![_secondTextField.text isValidPassword]) {
                [self.view makeCenterOffsetToast:@"请输入合法的密码"];
                return NO;
            }
            return YES;
        }
            break;
        default:
            return YES;
    }
}

- (void)finishInputAction
{
    if (![self validateInputText]) {
        return;
    }
    switch (_inputMode) {
        case HZInputModePlainTextInput: {
            [_delegate inputViewController:self didFinishWithText:_firstTextField.text];;
        }
            break;
        case HZInputModeSecureTextInput: {
            [_delegate inputViewController:self didFinishWithText:_firstTextField.text];
        }
            break;
        case HZInputModeMultiLineTextInput: {
            [_delegate inputViewController:self didFinishWithText:_textView.text];
        }
            break;
        case HZInputModeLoginAndPasswordInput: {
            [_delegate inputViewController:self didFinishWithUserName:_firstTextField.text pwd:_secondTextField.text];
        }
            break;
            
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTextPlaceholderDictionary:(NSDictionary *)placeholderDictionary
{
    if (_placeholderDictionary != placeholderDictionary) {
        _placeholderDictionary = placeholderDictionary;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
