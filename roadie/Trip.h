//
//  Trip.h
//  roadie
//
//  Created by Robin Wu on 12/3/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trip : NSObject

@property (nonatomic, strong) NSString *tripId;

- (id)init;
- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (Trip *)currentTrip;
+ (void)setCurrentTrip:(Trip *)currentTrip;
+ (void)clear;
+ (void)createTrip;

@end
