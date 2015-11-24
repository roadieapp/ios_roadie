//
//  HomeViewController.m
//  roadie
//
//  Created by Xin Suo on 11/18/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "HomeViewController.h"
#import "Constants.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavigationBar];
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
