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

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIViewController *currentVC;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UIViewController *blueViewController = [[BlueViewController alloc]init];
    UINavigationController *blueNVC = [[UINavigationController alloc] initWithRootViewController:blueViewController];
    
    UIViewController *redViewController = [[RedViewController alloc]init];
    UINavigationController *redNVC = [[UINavigationController alloc] initWithRootViewController:redViewController];
    
    self.viewControllers = [NSArray arrayWithObjects:blueNVC, redNVC, nil];
    
    self.hamburgerViewController.contentViewController = blueNVC;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.hamburgerViewController.contentViewController = self.viewControllers[indexPath.row];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Blue View";
            break;
        case 1:
            cell.textLabel.text = @"Red View";
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
