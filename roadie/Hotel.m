//
//  Hotel.m
//  roadie
//
//  Created by David Wang on 11/22/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "Hotel.h"

@implementation Hotel

- (id) initWithDictionary: (NSDictionary *) dictionary {
    self = [super init];
    
    if (self) {
        self.hotelID = dictionary[@"hotelID"];
        self.hotelName = dictionary[@"hotelName"];
        self.hotelAddress = dictionary[@"hotelAddress"];
        self.location = dictionary[@"location"];
        self.lat = [dictionary[@"lat"] doubleValue];
        self.lng = [dictionary[@"lng"] doubleValue];
        
        NSString *imageUrlString = dictionary[@"imageUrl"];
        self.imageUrl = [NSURL URLWithString:imageUrlString];
        
        // Note: need to work out the stars image url from CDN
//        NSString *starsUrlString = dictionary[@"starsUrl"];
//        self.starsUrl = [NSURL URLWithString:starsUrlString];
        
        // store price in NSString
        self.price = [dictionary[@"price"] intValue];
        
        self.currencyCode = dictionary[@"currencyCode"];
        self.amenities = dictionary[@"amenities"];
        self.hotelDescription = dictionary[@"description"];
        self.finePrint = dictionary[@"finePrint"];
    }
    
    return self;
}

@end
