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
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSURL *imageUrl;
@property (strong, nonatomic) NSString *location;
@property (assign, nonatomic) NSInteger price;
@property (strong, nonatomic) NSString *currencyCode;

@end
