//
//  MenuViewController.m
//  roadie
//
//  Created by Robin Wu on 11/22/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "MenuViewController.h"
#import "BlueViewController.h"
#import "RedViewController.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import "TripDetailController.h"
#import "User.h"
#import "Constants.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentVC;

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
    
    UIViewController *blueViewController = [[BlueViewController alloc]init];
    UINavigationController *blueNVC = [[UINavigationController alloc] initWithRootViewController:blueViewController];
    
    UIViewController *redViewController = [[RedViewController alloc]init];
    UINavigationController *logoutNVC = [[UINavigationController alloc] initWithRootViewController:redViewController];
    
    UIViewController *loginViewController = [[LoginViewController alloc]init];
    UINavigationController *loginNVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];

    UIViewController *homeViewController = [[HomeViewController alloc]init];
    UINavigationController *homeNVC = [[UINavigationController alloc] initWithRootViewController:homeViewController];

    UIViewController *tripDetailController = [[TripDetailController alloc]init];
    UINavigationController *tripNVC = [[UINavigationController alloc] initWithRootViewController:tripDetailController];

    self.viewControllers = [NSArray arrayWithObjects:loginNVC, homeNVC, tripNVC, blueNVC, logoutNVC, nil];
    
    User *user = [User currentUser];
    if (user != nil) {
        self.hamburgerViewController.contentViewController = homeNVC;
    } else {
        self.hamburgerViewController.contentViewController = loginNVC;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hamburgerViewController.contentViewController = self.viewControllers[indexPath.row];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Login";
            break;
        case 1:
            cell.textLabel.text = @"Home";
            break;
        case 2:
            cell.textLabel.text = @"My Trip";
            break;
        case 3:
            cell.textLabel.text = @"Settings";
            break;
        case 4:
            cell.textLabel.text = @"Logout";
            break;
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:21];
    cell.textLabel.textColor = [UIColor whiteColor];
    // use twitter color https://about.twitter.com/press/brand-assets
    cell.backgroundColor = [UIColor colorWithRed:85/255.0f green:172/255.0f blue:238/255.0f alpha:1.0f];
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
