//
//  Hotel.h
//  roadie
//
//  Created by David Wang on 11/22/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hotel : NSObject

@property (strong, nonatomic) NSString *hotelID;
@property (strong, nonatomic) NSString *hotelName;
@property (strong, nonatomic) NSString *hotelAddress;

// Note: title may be the same name as hotel name. to check later
@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSURL *imageUrl;

// location is the city, state info, something like Seattle, WA
@property (strong, nonatomic) NSString *location;

// Note: price is based on the date, it will be adjusted later
@property (assign, nonatomic) NSInteger price;
@property (strong, nonatomic) NSString *currencyCode;

@property (strong, nonatomic) NSURL *starsUrl;
@property (strong, nonatomic) NSString *amenities;
@property (strong, nonatomic) NSString *hotelDescription;
@property (strong, nonatomic) NSString *finePrint;

- (id) initWithDictionary: (NSDictionary *) dictionary;

@end
