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
#import "MenuCell.h"
#import "UserProfileCell.h"
#import "UIImageView+AFNetworking.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) NSArray *texts;
@property (strong, nonatomic) NSArray *icons;
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UserProfileCell" bundle:nil] forCellReuseIdentifier:@"UserProfileCell"];
}

- (void)viewDidAppear:(BOOL)animated {
    [self updateMenus];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *user = [User currentUser];
    if (user != nil) {
        if ([user hasProfileImage]) {
            if (indexPath.row == 0) {
                // nothing
            } else if (indexPath.row == 4) {
                [self presentLogoutMessage];
            } else {
                self.hamburgerViewController.contentViewController = self.viewControllers[indexPath.row - 1];
            }
        } else {
            if (indexPath.row == 3) {
                [self presentLogoutMessage];
            } else {
                self.hamburgerViewController.contentViewController = self.viewControllers[indexPath.row];
            }
        }
    } else {
        self.hamburgerViewController.contentViewController = self.viewControllers[indexPath.row];
    }
}

- (void)presentLogoutMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Signed out" message:@"You have been succesfully signed out." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [User logout];
        [self updateMenus];
        [self.tableView reloadData];
    }];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    User *user = [User currentUser];
    if (user != nil && [user hasProfileImage]) {
        return 5;
    } else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self updateMenus];
    
    User *user = [User currentUser];
    if (user != nil && [user.userType  isEqual: @"1"]) {
        if (indexPath.row == 0) {
            UserProfileCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
            [cell.profileImage setImageWithURL:[NSURL URLWithString:user.profileUrl]];
            cell.userNameLabel.text = user.username;
            cell.locationLabel.text = user.city;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            MenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
            cell.menuLabel.text = self.texts[indexPath.row - 1];
            [cell.iconImage setImage:[UIImage imageNamed:self.icons[indexPath.row - 1]]];
            return cell;
        }
    } else {
        MenuCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        cell.menuLabel.text = self.texts[indexPath.row];
        [cell.iconImage setImage:[UIImage imageNamed:self.icons[indexPath.row]]];
        return cell;
    }
}

- (void)updateMenus {
    if ([User currentUser]) {
        self.viewControllers = [NSArray arrayWithObjects:self.homeNVC, self.tripNVC, self.blueNVC, nil];
        self.hamburgerViewController.contentViewController = self.homeNVC;
        self.texts = [NSArray arrayWithObjects:@"Home", @"My Trip", @"Settings", @"Logout", nil];
        self.icons = [NSArray arrayWithObjects:@"homepage.png", @"trips.png", @"settings.png", @"logout.png", nil];
    } else {
        self.viewControllers = [NSArray arrayWithObjects:self.loginNVC, self.homeNVC, self.tripNVC, self.blueNVC, nil];
        self.hamburgerViewController.contentViewController = self.homeNVC;
        self.texts = [NSArray arrayWithObjects:@"Login", @"Home", @"My Trip", @"Settings", nil];
        self.icons = [NSArray arrayWithObjects:@"login.png", @"homepage.png", @"trips.png", @"settings.png", nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
