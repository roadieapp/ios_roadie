//
//  TripCell.m
//  roadie
//
//  Created by Robin Wu on 11/26/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "TripCell.h"

@interface TripCell()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *connectImageView;

@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *hotelAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkInLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkOutLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkInDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkOutDateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *bookedImageView;

@end

@implementation TripCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) setTripUnit:(TripUnit *)tripUnit {
    _tripUnit = tripUnit;
    
    self.locationLabel.text = tripUnit.location;
    [self.locationLabel sizeToFit];
    
    self.hotelNameLabel.text = tripUnit.hotelName;
    [self.hotelNameLabel sizeToFit];
    
    self.hotelAddressLabel.text = tripUnit.hotelAddress;
    [self.hotelAddressLabel sizeToFit];
    
    if ([tripUnit.hotelName isEqualToString:@""]) {
        [self.checkInLabel setHidden:YES];
        [self.checkOutLabel setHidden:YES];
    }
    
    self.checkInDateLabel.text = tripUnit.hotelCheckIn;
    self.checkOutDateLabel.text = tripUnit.hotelCheckOut;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
