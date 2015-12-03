//
//  MenuViewController.m
//  roadie
//
//  Created by Robin Wu on 11/22/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "MenuViewController.h"
#import "DataInputViewController.h"
#import "RedViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "TripDetailController.h"
#import "User.h"
#import "Constants.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) NSArray *texts;
@property (strong, nonatomic) UINavigationController *blueNVC;
@property (strong, nonatomic) UINavigationController *loginNVC;
@property (strong, nonatomic) UINavigationController *homeNVC;
@property (strong, nonatomic) UINavigationController *tripNVC;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController.navigationBar setBarTintColor:[[Constants sharedInstance] themeColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UIViewController *blueViewController = [[DataInputViewController alloc]init];
    self.blueNVC = [[UINavigationController alloc] initWithRootViewController:blueViewController];
    
    UIViewController *loginViewController = [[LoginViewController alloc]init];
    self.loginNVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];

    UIViewController *homeViewController = [[HomeViewController alloc]init];
    self.homeNVC = [[UINavigationController alloc] initWithRootViewController:homeViewController];

    UIViewController *tripDetailController = [[TripDetailController alloc]init];
    self.tripNVC = [[UINavigationController alloc] initWithRootViewController:tripDetailController];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateMenus];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([User currentUser] && indexPath.row == 3) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Signed out" message:@"You have been succesfully signed out." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [User logout];
            [self updateMenus];
            [self.tableView reloadData];
        }];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        self.hamburgerViewController.contentViewController = self.viewControllers[indexPath.row];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [self updateMenus];
    cell.textLabel.text = self.texts[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [[Constants sharedInstance] themeColor];
    
    return cell;
}

- (void)updateMenus {
    if ([User currentUser]) {
        self.viewControllers = [NSArray arrayWithObjects:self.homeNVC, self.tripNVC, self.blueNVC, nil];
        self.hamburgerViewController.contentViewController = self.homeNVC;
        self.texts = [NSArray arrayWithObjects:@"Home", @"My Trip", @"Settings", @"Logout", nil];
    } else {
        self.viewControllers = [NSArray arrayWithObjects:self.loginNVC, self.homeNVC, self.tripNVC, self.blueNVC, nil];
        self.hamburgerViewController.contentViewController = self.homeNVC;
        self.texts = [NSArray arrayWithObjects:@"Login", @"Home", @"My Trip", @"Settings", nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
