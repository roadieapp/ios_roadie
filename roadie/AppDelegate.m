//
//  AppDelegate.m
//  roadie
//
//  Created by Xin Suo on 11/18/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;
#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "User.h"
#import "Constants.h"
#import "HamburgerViewController.h"
#import "MenuViewController.h"
#import "SearchResultViewController.h"
#import "TripDetailController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse setApplicationId:@"aYDdJFZaS5jPGV4y3dWf2ZErM4nk35hvoO9xThQh"
                  clientKey:@"KzcNGKS5NXC06AohgfWQyOWFOXpm1eJP2cpv1AGt"];
    
    [GMSServices provideAPIKey:@"AIzaSyAR1Ya-VtjBagXDulRx5IuE1q6UAI_nUnU"];

    User *user = [User currentUser];
    UINavigationController *nvc;
    if (user != nil) {
        nvc = [[UINavigationController alloc] initWithRootViewController:[[HomeViewController alloc] init]];
    } else {
        nvc = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    }
    
    self.window.rootViewController = nvc;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = [[Constants sharedInstance] themeColor];
    [self.window.rootViewController.view addSubview:view];

    
    // Begin: init the hamburger menu block
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    
//    HamburgerViewController *hamburgerVC = [[HamburgerViewController alloc] init];
//    
//    self.window.rootViewController = hamburgerVC;
//    MenuViewController *menuVC = [[MenuViewController alloc] init];
//    
//    [menuVC setHamburgerViewController:hamburgerVC];
//    [hamburgerVC setMenuViewController:menuVC];
    // End: init the hamburger menu block
    
    // Begin: TripDetailController block
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    TripDetailController *tripDetailController = [[TripDetailController alloc] init];
//    self.window.rootViewController = tripDetailController;
    // End: TripDetailController block

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
