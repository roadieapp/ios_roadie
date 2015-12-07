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

@end

@implementation HotelDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCalendar];
//    [self initHotel];
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
    [self.selectDatesButton setTitle:title forState:UIControlStateNormal];
}

- (IBAction)onSelectDates:(id)sender {
    [self loadCalendar];
}

- (void) initHotel {
    NSDictionary *dictionary = @{@"location": @"Portland, OR",
                                 @"hotelAddress": @"400 SW Broadway, Portland, OR 97205",
                                 @"hotelName": @"Hotel Lucia",
                                 @"hotelId": @"12345",
                                 @"imageUrl": @"http://exp.cdn-hotels.com/hotels/1000000/20000/16000/15988/15988_118_z.jpg",
                                 @"starsUrl": @"",
                                 @"price": @"189",
                                 @"currencyCode": @"USD",
                                 @"amenities": @"Amenities include 2 eateries, an exercise room, a business center and meeting space. The property is also home to a collection of work by local Pulitzer Prize-winning photographer, David Hume Kennerly.",
                                 @"description": @"Set in a 1909 landmark, this chic downtown hotel is 3 blocks from the Pioneer Square North MAX Station and 7 blocks from the Governor Tom McCall Waterfront Park. ",
                                 @"finePrint": @"The posh rooms feature pillow-top mattresses, flat-screen TVs and free WiFi. Suites add sitting areas."};
    
    _hotel = [[Hotel alloc]initWithDictionary:dictionary];
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
    tripUnitObject[@"hotelAddress"] = [[self hotel]hotelAddress];
    tripUnitObject[@"location"] = [[self hotel]location];
    tripUnitObject[@"checkIn"] = @"2015-12-09";
    tripUnitObject[@"checkOut"] = @"2015-12-10";
    tripUnitObject[@"tripId"] = [[Trip currentTrip]tripId];
    
    [tripUnitObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Trip Unit has been saved");
            
        } else {
            // There was a problem, check error.description
            NSLog(@"Error in saving Trip Unit");
        }
    }];

    
}

@end
