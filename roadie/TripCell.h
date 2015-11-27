//
//  TripCell.h
//  roadie
//
//  Created by Robin Wu on 11/26/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripUnit.h"

@interface TripCell : UITableViewCell

@property (nonatomic, strong) TripUnit *tripUnit;

- (void) setTripUnit:(TripUnit *)tripUnit;

@end
