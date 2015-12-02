//
//  BlueViewController.m
//  roadie
//
//  Created by Robin Wu on 11/22/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "DataInputViewController.h"
#import "Parse.h"

@interface DataInputViewController ()

@property (nonatomic, strong) NSArray *hotels;
@property (nonatomic, strong) NSDictionary *trip;
@property (nonatomic, strong) NSArray *tripUnits;

@end

@implementation DataInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addHotelsTapped:(UIButton *)sender {
    NSLog(@"Add Hotels");
//    [self addHotels];
}

- (void) addHotels {
    self.hotels = @[
                    @{@"location": @"Portland, OR",
                      @"hotelAddress": @"400 SW Broadway, Portland, OR 97205",
                      @"lat": @45.5210634,
                      @"lng": @-122.6805098,
                      @"hotelName": @"Hotel Lucia",
                      @"hotelId": @"12345",
                      @"imageUrl": @"http://exp.cdn-hotels.com/hotels/1000000/20000/16000/15988/15988_118_z.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"4.0",
                      @"price": @"189",
                      @"currencyCode": @"USD",
                      @"amenities": @"Amenities include 2 eateries, an exercise room, a business center and meeting space. The property is also home to a collection of work by local Pulitzer Prize-winning photographer, David Hume Kennerly.",
                      @"description": @"Set in a 1909 landmark, this chic downtown hotel is 3 blocks from the Pioneer Square North MAX Station and 7 blocks from the Governor Tom McCall Waterfront Park. ",
                      @"finePrint": @"The posh rooms feature pillow-top mattresses, flat-screen TVs and free WiFi. Suites add sitting areas."},
                    @{@"location": @"Portland, OR",
                      @"hotelAddress": @"506 SW Washington St, Portland, OR 97204",
                      @"lat": @45.5201256,
                      @"lng": @-122.6794443,
                      @"hotelName": @"Hotel Monaco Portland",
                      @"hotelId": @"12346",
                      @"imageUrl": @"http://vp.cdn.cityvoterinc.com/GetImage.ashx?img=00/00/00/39/01/98/390198-367513.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"3.5",
                      @"price": @"229",
                      @"currencyCode": @"USD",
                      @"amenities": @"Amenities include 2 eateries, an exercise room, a business center and meeting space. The property is also home to a collection of work by local Pulitzer Prize-winning photographer, David Hume Kennerly.",
                      @"description": @"Set in a 1909 landmark, this chic downtown hotel is 3 blocks from the Pioneer Square North MAX Station and 7 blocks from the Governor Tom McCall Waterfront Park. ",
                      @"finePrint": @"The posh rooms feature pillow-top mattresses, flat-screen TVs and free WiFi. Suites add sitting areas."},
                    @{@"location": @"Portland, OR",
                      @"hotelAddress": @"319 SW Pine St, Portland, OR 97204",
                      @"lat": @45.5215199,
                      @"lng": @-122.6765451,
                      @"hotelName": @"Embassy Suites by Hilton",
                      @"hotelId": @"12347",
                      @"imageUrl": @"http://embassysuites3.hilton.com/resources/media/es/PDXPSES/en_US/img/shared/full_page_image_gallery/main/ES_entrance2_2_712x342_FitToBoxSmallDimension_LowerCenter.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"4.0",
                      @"price": @"253",
                      @"currencyCode": @"USD",
                      @"amenities": @"Amenities include 2 eateries, an exercise room, a business center and meeting space. The property is also home to a collection of work by local Pulitzer Prize-winning photographer, David Hume Kennerly.",
                      @"description": @"Set in a 1909 landmark, this chic downtown hotel is 3 blocks from the Pioneer Square North MAX Station and 7 blocks from the Governor Tom McCall Waterfront Park. ",
                      @"finePrint": @"The posh rooms feature pillow-top mattresses, flat-screen TVs and free WiFi. Suites add sitting areas."}
                   ];
    
    for (NSDictionary *dictionary in self.hotels) {
        
        PFObject *hotelObject = [PFObject objectWithClassName:@"Hotel"];
        hotelObject[@"location"] = dictionary[@"location"];
        hotelObject[@"hotelAddress"] = dictionary[@"hotelAddress"];
        hotelObject[@"hotelName"] = dictionary[@"hotelName"];
        hotelObject[@"hotelId"] = dictionary[@"hotelId"];
        hotelObject[@"imageUrl"] = dictionary[@"imageUrl"];
        hotelObject[@"starsUrl"] = dictionary[@"starsUrl"];
        hotelObject[@"starRating"] = dictionary[@"starRating"];
        hotelObject[@"price"] = dictionary[@"price"];
        hotelObject[@"lat"] = dictionary[@"lat"];
        hotelObject[@"lng"] = dictionary[@"lng"];
        hotelObject[@"currencyCode"] = dictionary[@"currencyCode"];
        hotelObject[@"amenities"] = dictionary[@"amenities"];
        hotelObject[@"description"] = dictionary[@"description"];
        hotelObject[@"finePrint"] = dictionary[@"finePrint"];
        
        [hotelObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                NSLog(@"Hotel has been saved");
            } else {
                // There was a problem, check error.description
                NSLog(@"Error");
            }
        }];
        
    }
}

- (IBAction)addTripTapped:(UIButton *)sender {
    NSLog(@"Add Trip");
//    [self addTrip];
}

- (void) addTrip {
    self.trip = @{@"tripId": @"12345",
                  @"tripName": @"Trip from Seattle WA to Los Angelos CA 20151201",
                  @"from": @"Seattle, WA",
                  @"to": @"Los Angelos, CA",
                  };
    
    PFObject *tripObject = [PFObject objectWithClassName:@"Trip"];
    tripObject[@"tripId"] = self.trip[@"tripId"];
    tripObject[@"tripName"] = self.trip[@"tripName"];
    tripObject[@"from"] = self.trip[@"from"];
    tripObject[@"to"] = self.trip[@"to"];
    
    [tripObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Trip has been saved");
        } else {
            // There was a problem, check error.description
            NSLog(@"Error");
        }
    }];
    
}


- (IBAction)addTripUnitTapped:(UIButton *)sender {
    NSLog(@"Add Trip Unit");
//    [self addTripUnits];
}

- (void) addTripUnits {
    self.tripUnits = @[
                       
                    @{@"tripId": @"12345",
                      @"hotelAddress": @"400 SW Broadway, Portland, OR 97205",
                      @"hotelName": @"Hotel Lucia",
                      @"location": @"Portland, OR",
                      @"checkIn": @"2015-12-01",
                      @"checkOut": @"2015-12-03"
                      },
                    @{@"tripId": @"12345",
                      @"hotelAddress": @"55 Cyril Magnin St, San Francisco, CA 94102",
                      @"hotelName": @"Parc 55",
                      @"location": @"San Francisco, CA",
                      @"checkIn": @"2015-12-04",
                      @"checkOut": @"2015-12-07"
                      }
                    
                    ];
    
    for (NSDictionary *dictionary in self.tripUnits) {
        
        PFObject *tripUnitObject = [PFObject objectWithClassName:@"TripUnit"];
        tripUnitObject[@"tripId"] = dictionary[@"tripId"];
        tripUnitObject[@"hotelAddress"] = dictionary[@"hotelAddress"];
        tripUnitObject[@"location"] = dictionary[@"location"];
        tripUnitObject[@"checkIn"] = dictionary[@"checkIn"];
        tripUnitObject[@"checkOut"] = dictionary[@"checkOut"];
        
        [tripUnitObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                NSLog(@"Trip Unit has been saved");
            } else {
                // There was a problem, check error.description
                NSLog(@"Error");
            }
        }];
        
    }

}



@end
