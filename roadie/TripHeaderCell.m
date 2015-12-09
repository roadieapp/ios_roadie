//
//  TripHeaderCell.m
//  roadie
//
//  Created by Robin Wu on 11/27/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "TripHeaderCell.h"

@interface TripHeaderCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistanceConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *connectImageView;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *startDateValueLabel;

@end

@implementation TripHeaderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) setTripUnit:(TripUnit *)tripUnit withHeader:(BOOL)header {
    _tripUnit = tripUnit;
    
    self.locationLabel.text = tripUnit.location;
    [self.locationLabel sizeToFit];
    NSLog(@"Trip Start Time: %@", tripUnit.tripStartTime);
    
    if (header) {
        self.bottomDistanceConstraint.constant = 48;
    } else {
        [self.connectImageView setHidden:YES];
        [self.startDateLabel setHidden:YES];
        [self.startDateValueLabel setHidden:YES];
        self.bottomDistanceConstraint.constant = 6;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
