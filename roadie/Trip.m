//
//  Trip.m
//  roadie
//
//  Created by Robin Wu on 12/3/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "Trip.h"

@interface Trip()

@property (nonatomic, strong) NSDictionary *dictionary;

@end


@implementation Trip

static Trip *_currentTrip = nil;

NSString * const roadieCurrentTripKey = @"roadieCurrentTripKey";

- (id)init {
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
    [mutableDict setObject:[self createTripId] forKey:@"tripId"];
    return [self initWithDictionary:mutableDict];
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.dictionary = dictionary;
        self.tripId = dictionary[@"tripId"];
    }
    return self;
}

+ (Trip *)currentTrip {
    if (_currentTrip == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:roadieCurrentTripKey];
        if (data != nil) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentTrip = [[Trip alloc] initWithDictionary:dictionary];
        }
    }
    
    return _currentTrip;

}

+ (void)setCurrentTrip:(Trip *)currentTrip {
    _currentTrip = currentTrip;
    
    if (_currentTrip != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:currentTrip.dictionary options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:roadieCurrentTripKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:roadieCurrentTripKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)createTrip {
    Trip *myTrip = [[Trip alloc] init];
    [Trip setCurrentTrip:myTrip];
}

+ (void)clear {
    [Trip setCurrentTrip:nil];
}

- (NSString *) createTripId {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    
    NSDate *date = [NSDate date];
    
    return [dateFormatter stringFromDate:date];
}

@end
