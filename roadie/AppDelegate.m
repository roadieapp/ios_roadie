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
#import "HotelDetailController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    [Parse setApplicationId:@"wmswWgLA79PXgf0XbE6yKp5YCWjUvxH5pmJb61eu"
                  clientKey:@"qCNpMHDhdzvNRADDTpJDUeY71zQyE4hc2nvbTtXQ"];
    
    [GMSServices provideAPIKey:@"AIzaSyAR1Ya-VtjBagXDulRx5IuE1q6UAI_nUnU"];
    
    // Begin: init the hamburger menu block
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    HamburgerViewController *hamburgerVC = [[HamburgerViewController alloc] init];
    
    self.window.rootViewController = hamburgerVC;
    MenuViewController *menuVC = [[MenuViewController alloc] init];
    UINavigationController *menuNVC = [[UINavigationController alloc]initWithRootViewController:menuVC];
    
    [menuVC setHamburgerViewController:hamburgerVC];
    [hamburgerVC setMenuViewController:menuNVC];
    // End: init the hamburger menu block
    
    // Begin: TripDetailController block
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    TripDetailController *tripDetailController = [[TripDetailController alloc] init];
//    self.window.rootViewController = tripDetailController;
    // End: TripDetailController block

    // Begin: HotelDetailController block
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    HotelDetailController *hotelDetailController = [[HotelDetailController alloc] init];
//    self.window.rootViewController = hotelDetailController;
    // End: HotelDetailController block

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

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

@end
