//
//  HamburgerViewController.m
//  Canvas
//
//  Created by Robin Wu on 11/12/15.
//  Copyright © 2015 Robin Wu. All rights reserved.
//

#import "HamburgerViewController.h"
#import "MenuViewController.h"

@interface HamburgerViewController ()

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginConstraint;

@property (assign, nonatomic) CGFloat originalLeftMargin;

@end

@implementation HamburgerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
                        
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalLeftMargin = self.leftMarginConstraint.constant;
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.leftMarginConstraint.constant = self.originalLeftMargin + translation.x;
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3 animations:^{
            if (velocity.x > 0) {
                // open
                self.leftMarginConstraint.constant = self.view.frame.size.width - 50;
            } else {
                // close
                self.leftMarginConstraint.constant = 0;
            }
            [self.view layoutIfNeeded];
        }];
    }
}

- (void) setMenuViewController:(UIViewController *)menuViewController {
    _menuViewController = menuViewController;
    
    [self.view layoutIfNeeded];
    [self.menuView addSubview:menuViewController.view];
}

- (void) setContentViewController:(UIViewController *)contentViewController {
    _contentViewController = contentViewController;
    
    [self.view layoutIfNeeded];
    
    [self.contentViewController willMoveToParentViewController:self];
    [self.contentView addSubview:contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        // close
        self.leftMarginConstraint.constant = 0;
        [self.view layoutIfNeeded];
    }];

}

- (void) hideContentController:(UIViewController *) content {
    if (content != nil) {
        [content willMoveToParentViewController:nil];
        [content.view removeFromSuperview];
        [content removeFromParentViewController];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
