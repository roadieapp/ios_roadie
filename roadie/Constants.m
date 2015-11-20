//
//  Constants.m
//  roadie
//
//  Created by Xin Suo on 11/19/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "Constants.h"

@implementation Constants

+ (Constants *)sharedInstance {
    static Constants *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[Constants alloc] init];
        }
    });

    return instance;
}

- (UIColor *)themeColor {
    return [UIColor colorWithRed:82/255.0 green:104/255.0 blue:185/255.0 alpha:1];
}

@end
