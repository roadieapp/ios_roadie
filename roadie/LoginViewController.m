//
//  LoginViewController.m
//  roadie
//
//  Created by Xin Suo on 11/18/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "LoginViewController.h"
#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Constants.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
    [self setUpTextFields];
    [self setUpTapGestureRecognizer];
}

- (IBAction)onLoginTapped:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if (user) {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
            dictionary[@"username"] = user.username;
            [User setCurrentUser:[[User alloc] initWithDictionary:dictionary]];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Log In Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (IBAction)onSignUpTapped:(id)sender {
    UIViewController *vc = [[SignupViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)setUpTapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setUpNavigationBar {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // set background color
    [navigationBar setBarTintColor:[[Constants sharedInstance] themeColor]];
    [navigationBar setTranslucent:NO];
    // remove bottom line
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)setUpTextFields {
    // username text field border style
    UIBezierPath *usernameMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:self.usernameTextField.bounds
                                                                        byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                                              cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *usernameMaskLayer = [[CAShapeLayer alloc] init];
    usernameMaskLayer.frame = self.usernameTextField.bounds;
    usernameMaskLayer.path = usernameMaskPathWithRadiusTop.CGPath;
    [usernameMaskLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    CALayer *usernameLayer = self.usernameTextField.layer;
    [self.usernameTextField setTextAlignment:NSTextAlignmentLeft];
    [self.usernameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    usernameLayer.shadowOpacity = 0.0;
    [usernameLayer addSublayer:usernameMaskLayer];
    
    // password text field border style
    UIBezierPath *passwordMaskPathWithRadiusBottom = [UIBezierPath bezierPathWithRoundedRect:self.passwordTextField.bounds
                                                                           byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                                                 cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *passwordMaskLayer = [[CAShapeLayer alloc] init];
    passwordMaskLayer.frame = self.passwordTextField.bounds;
    passwordMaskLayer.path = passwordMaskPathWithRadiusBottom.CGPath;
    [passwordMaskLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    CALayer *passwordLayer = self.passwordTextField.layer;
    [self.passwordTextField setTextAlignment:NSTextAlignmentLeft];
    [self.passwordTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    passwordLayer.shadowOpacity = 0.0;
    [passwordLayer addSublayer:passwordMaskLayer];
    
    // password text field secure text entry
    self.passwordTextField.secureTextEntry = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
