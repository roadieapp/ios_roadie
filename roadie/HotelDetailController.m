//
//  HotelDetailController.m
//  roadie
//
//  Created by Robin Wu on 11/27/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "HotelDetailController.h"
#import "UIImageView+AFNetworking.h"

@interface HotelDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *hotelImageView;

@property (weak, nonatomic) IBOutlet UILabel *hotelName;

@property (weak, nonatomic) IBOutlet UIImageView *hotelStarsImageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *amenitiesLabel;

@property (weak, nonatomic) IBOutlet UILabel *hotelAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *finePrintLabel;

@property (weak, nonatomic) IBOutlet UITextField *checkInTextField;

@property (weak, nonatomic) IBOutlet UITextField *checkOutTextField;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (weak, nonatomic) IBOutlet UIView *noticeView;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation HotelDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self initHotel];
    [self updateView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    [layer setCornerRadius:6.0];
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [layer setBorderWidth:3.0];
    [layer setMasksToBounds:YES];
    [self.hotelImageView setImageWithURL:self.hotel.imageUrl];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.hotel.price];
    
    self.descriptionLabel.text = self.hotel.hotelDescription;
    [self.descriptionLabel sizeToFit];
    
    self.amenitiesLabel.text = self.hotel.amenities;
    [self.amenitiesLabel sizeToFit];
    
    self.finePrintLabel.text = self.hotel.finePrint;
    [self.finePrintLabel sizeToFit];
    
    self.checkInTextField.text = [self defaultCheckInDate];
    self.checkOutTextField.text = [self defaultCheckOutDate];
}

- (NSString *) defaultCheckInDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *) defaultCheckOutDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *now = [NSDate date];
    int daysToAdd = 1;
    NSDate *newDate = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
    return [formatter stringFromDate:newDate];
}


- (IBAction)bookButtonTapped:(UIButton *)sender {
    NSLog(@"Hotel has been booked");
    [self displayNoticeInfo];
}

- (void) displayNoticeInfo {
    NSString *message = @"Booked";
    
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

@end
