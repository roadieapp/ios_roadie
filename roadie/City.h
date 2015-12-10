//
//  CityHotels.h
//  roadie
//
//  Created by David Wang on 12/6/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface City : NSObject

@property(nonatomic, strong) NSArray *hotels;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *location;
@property (assign, nonatomic) double lat;
@property (assign, nonatomic) double lng;

@end
