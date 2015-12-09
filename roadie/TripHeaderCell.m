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

@property (nonatomic, strong) NSDateFormatter *dateTimeformatter;
@property (nonatomic, strong) NSDateFormatter *dateOnlyFormatter;

@end

@implementation TripHeaderCell

- (void)awakeFromNib {
    // Initialization code
    
    self.dateTimeformatter = [[NSDateFormatter alloc] init];
    [self.dateTimeformatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [self.dateTimeformatter setDateFormat:@"yyyyMMddHHmm"];
    
    self.dateOnlyFormatter = [[NSDateFormatter alloc] init];
    [self.dateOnlyFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [self.dateOnlyFormatter setDateFormat:@"yyyy-MM-dd"];
}

- (void) setTripUnit:(TripUnit *)tripUnit withHeader:(BOOL)header {
    _tripUnit = tripUnit;
    
    self.locationLabel.text = tripUnit.location;
    [self.locationLabel sizeToFit];
    
    NSLog(@"Trip Start Time: %@", tripUnit.tripStartTime);
    NSDate *date = [self.dateTimeformatter dateFromString:tripUnit.tripStartTime];
    NSString *startDate = [self.dateOnlyFormatter stringFromDate:date];
    self.startDateValueLabel.text = startDate;
    
    if (header) {
        self.bottomDistanceConstraint.constant = 48;
        [self.connectImageView setHidden:NO];
        [self.startDateLabel setHidden:NO];
        [self.startDateValueLabel setHidden:NO];
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
