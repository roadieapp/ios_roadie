//
//  HotelDetailController.m
//  roadie
//
//  Created by Robin Wu on 11/27/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "HotelDetailController.h"
#import "UIImageView+AFNetworking.h"
#import "Constants.h"
#import "SSMaterialCalendarPicker.h"
#import "Trip.h"
#import "Parse.h"

@interface HotelDetailController () <SSMaterialCalendarPickerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *hotelImageView;
@property (weak, nonatomic) IBOutlet UILabel *hotelName;
@property (weak, nonatomic) IBOutlet UIImageView *hotelStarsImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *amenitiesLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotelAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *finePrintLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectDatesButton;

@property (nonatomic, strong) SSMaterialCalendarPicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDateFormatter *dataFormatter;

@property (nonatomic, strong) NSString *checkInDate;
@property (nonatomic, strong) NSString *checkOutDate;

@end

@implementation HotelDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCalendar];
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initCalendar {
    self.datePicker = [SSMaterialCalendarPicker initCalendarOn:self.view withDelegate:self];
    self.datePicker.calendarTitle = @"Select Dates";
    self.datePicker.primaryColor = [Constants sharedInstance].themeColor;
    self.datePicker.secondaryColor = [Constants sharedInstance].themeColor;
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [self.formatter setDateFormat:@"MM/dd/yy"];
    
    self.dataFormatter = [[NSDateFormatter alloc] init];
    [self.dataFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [self.dataFormatter setDateFormat:@"yyyy-MM-dd"];
}

- (void)loadCalendar {
    if (![self.selectDatesButton.currentTitle  isEqual: @"Select Dates"]) {
        NSArray *dates = [self.selectDatesButton.currentTitle componentsSeparatedByString:@" - "];
        self.datePicker.startDate = [self.formatter dateFromString:dates[0]];
        self.datePicker.endDate = [self.formatter dateFromString:dates[1]];
    }
    [self.datePicker showAnimated];
}

- (void)rangeSelectedWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate {
    NSString *title = [NSString stringWithFormat:@"%@ - %@", [self.formatter stringFromDate:startDate], [self.formatter stringFromDate:endDate]];
    
    self.checkInDate = [self.dataFormatter stringFromDate:startDate];
    self.checkOutDate = [self.dataFormatter stringFromDate:endDate];
    
    [self.selectDatesButton setTitle:title forState:UIControlStateNormal];
}

- (IBAction)onSelectDates:(id)sender {
    [self loadCalendar];
}

- (void) updateView {
    self.hotelName.text = self.hotel.hotelName;
    [self.hotelName sizeToFit];
    
    self.hotelAddressLabel.text = self.hotel.hotelAddress;
    [self.hotelAddressLabel sizeToFit];
    
    CALayer *layer = [self.hotelImageView layer];
    [layer setMasksToBounds:YES];
    [self.hotelImageView setImageWithURL:self.hotel.imageUrl];
    
    NSString *starImageName = [NSString stringWithFormat:@"%@_%@", self.hotel.starRating, @"stars"];
    self.hotelStarsImageView.image = [UIImage imageNamed: starImageName];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.hotel.price];
    
    self.descriptionLabel.text = self.hotel.hotelDescription;
    [self.descriptionLabel sizeToFit];
    
    self.amenitiesLabel.text = self.hotel.amenities;
    [self.amenitiesLabel sizeToFit];
    
    self.finePrintLabel.text = self.hotel.finePrint;
    [self.finePrintLabel sizeToFit];
}

- (IBAction)bookButtonTapped:(UIButton *)sender {
    if (self.checkInDate == nil || self.checkOutDate == nil) {
        [self showDateNotSelectedError];
        return;
    }
    [self displayNoticeInfo];
}

- (void) displayNoticeInfo {
    NSString *message = @"Added to trip!";
    
    [self addToTrip];
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void) addToTrip {
    PFObject *tripUnitObject = [PFObject objectWithClassName:@"TripUnit"];
    tripUnitObject[@"hotelName"] = [[self hotel]hotelName];
    tripUnitObject[@"hotelAddress"] = [[self hotel]hotelAddress];
    tripUnitObject[@"location"] = [[self hotel]location];
    
    tripUnitObject[@"hotelCheckIn"] = self.checkInDate;
    tripUnitObject[@"hotelCheckOut"] = self.checkOutDate;
    tripUnitObject[@"tripId"] = [[Trip currentTrip]tripId];
    tripUnitObject[@"booked"] = [NSNumber numberWithBool:NO];
    
    [tripUnitObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Trip Unit has been saved");
            
        } else {
            // There was a problem, check error.description
            NSLog(@"Error in saving Trip Unit: %@ %@", error, [error userInfo]);
        }
    }];    
}

- (void) showDateNotSelectedError {
    NSString *errorString = @"Please select check in/out dates";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Trip Error" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
