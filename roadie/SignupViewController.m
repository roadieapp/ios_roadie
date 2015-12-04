//
//  SignupViewController.m
//  roadie
//
//  Created by Xin Suo on 11/18/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "SignupViewController.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "HomeViewController.h"
#import "HamburgerViewController.h"
#import "MenuViewController.h"

@interface SignupViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTextFields];
    [self setUpTapGestureRecognizer];
}

- (IBAction)onSignUpTapped:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameTextField.text;
    user.password = self.passwordTextField.text;
    user.email = self.emailTextField.text;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            HamburgerViewController *hamburgerVC = [[HamburgerViewController alloc] init];
            MenuViewController *menuVC = [[MenuViewController alloc] init];
            UINavigationController *menuNVC = [[UINavigationController alloc]initWithRootViewController:menuVC];
            [menuVC setHamburgerViewController:hamburgerVC];
            [hamburgerVC setMenuViewController:menuNVC];
            [self presentViewController:hamburgerVC animated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Cannot create account" message:errorString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (IBAction)onAlreadyHaveAnAccountTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpTapGestureRecognizer {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setUpTextFields {
    // email text field border style
    UIBezierPath *emailMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:self.emailTextField.bounds
                                                                        byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                                              cornerRadii:CGSizeMake(4.0, 4.0)];
    
    CAShapeLayer *emailMaskLayer = [[CAShapeLayer alloc] init];
    emailMaskLayer.frame = self.emailTextField.bounds;
    emailMaskLayer.path = emailMaskPathWithRadiusTop.CGPath;
    [emailMaskLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    CALayer *emailLayer = self.emailTextField.layer;
    [self.emailTextField setTextAlignment:NSTextAlignmentLeft];
    [self.emailTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    emailLayer.shadowOpacity = 0.0;
    [emailLayer addSublayer:emailMaskLayer];
    
    // username text field border style
    UIBezierPath *usernameMaskPathWithoutRadius = [UIBezierPath bezierPathWithRoundedRect:self.emailTextField.bounds
                                                                     byRoundingCorners:UIRectCornerAllCorners
                                                                           cornerRadii:CGSizeMake(0.0, 0.0)];
    
    CAShapeLayer *usernameMaskLayer = [[CAShapeLayer alloc] init];
    usernameMaskLayer.frame = self.usernameTextField.bounds;
    usernameMaskLayer.path = usernameMaskPathWithoutRadius.CGPath;
    [usernameMaskLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    CALayer *usernameLayer = self.usernameTextField.layer;
    [self.usernameTextField setTextAlignment:NSTextAlignmentLeft];
    [self.usernameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    usernameMaskLayer.shadowOpacity = 0.0;
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
    
    // email text field keyboard type
    [self.emailTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    
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
