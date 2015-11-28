//
//  TripHeaderCell.h
//  roadie
//
//  Created by Robin Wu on 11/27/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TripUnit.h"

@interface TripHeaderCell : UITableViewCell

@property (nonatomic, strong) TripUnit *tripUnit;

- (void) setTripUnit:(TripUnit *)tripUnit withHeader:(BOOL)header;


@end
