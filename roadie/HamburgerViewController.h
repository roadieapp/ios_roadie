//
//  HamburgerViewController.h
//  Canvas
//
//  Created by Robin Wu on 11/12/15.
//  Copyright © 2015 Robin Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HamburgerViewController : UIViewController

@property (strong, nonatomic) UIViewController *menuViewController;
@property (strong, nonatomic) UIViewController *contentViewController;

- (void) setMenuViewController:(UIViewController *)menuViewController;
- (void) setContentViewController:(UIViewController *)contentViewController;

@end
