//
//  TripUnit.h
//  roadie
//
//  Created by Robin Wu on 11/26/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TripUnit : NSObject

@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *tripStartTime;
@property (strong, nonatomic) NSString *hotelName;
@property (strong, nonatomic) NSString *hotelAddress;
@property (strong, nonatomic) NSString *hotelCheckIn;
@property (strong, nonatomic) NSString *hotelCheckOut;

- (id) initWithDictionary: (NSDictionary *) dictionary;

+ (NSArray *) tripWithArray: (NSArray *)array;

@end
