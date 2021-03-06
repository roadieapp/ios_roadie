//
//  User.m
//  roadie
//
//  Created by Xin Suo on 11/18/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "User.h"

@interface User()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation User

static User *_currentUser = nil;

NSString * const roadieCurrentUserKey = @"roadieCurrentUserKey";

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.username = dictionary[@"username"];
        self.profileUrl = dictionary[@"profileUrl"];
        self.userType = dictionary[@"userType"];
        self.city = dictionary[@"city"];
    }
    return self;
}

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:roadieCurrentUserKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentUser;
}

+ (void)setCurrentUser:(User *)currentUser {
    _currentUser = currentUser;
    
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentUser.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:roadieCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:roadieCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"username"] = self.username;
    dictionary[@"profileUrl"] = self.profileUrl;
    dictionary[@"userType"] = self.userType;
    dictionary[@"city"] = self.city;
    return dictionary;
}

+ (BOOL)hasProfileImage {
    if (_currentUser != nil && [_currentUser.userType isEqual:@"1"]) {
        return true;
    } else {
        return false;
    }
}

+ (void)logout {
    [User setCurrentUser:nil];
}

@end
