//
//  HotelViewCell.h
//  roadie
//
//  Created by David Wang on 11/22/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hotel.h"

@interface HotelViewCell : UITableViewCell

@property (nonatomic, strong) Hotel *hotel;

- (void) setHotel: (Hotel *)hotel;

@end
