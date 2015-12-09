//
//  TripUnit.m
//  roadie
//
//  Created by Robin Wu on 11/26/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "TripUnit.h"

@implementation TripUnit

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    
    if (self) {
        self.location = dictionary[@"location"];
        self.tripStartTime = dictionary[@"tripStartTime"];
        self.hotelName = dictionary[@"hotelName"];
        self.hotelAddress = dictionary[@"hotelAddress"];
        self.hotelCheckIn = dictionary[@"hotelCheckIn"];
        self.hotelCheckOut = dictionary[@"hotelCheckOut"];
        self.booked = dictionary[@"booked"];
    }
    
    return self;
}

+ (NSArray *) tripWithArray: (NSArray *)array {
    NSMutableArray *trip = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [trip addObject:[[TripUnit alloc] initWithDictionary:dictionary]];
    }
    
    return trip;    
}

@end
