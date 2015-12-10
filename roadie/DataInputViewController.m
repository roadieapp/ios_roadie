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
@property (nonatomic, strong) NSArray *tripLocations;

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
                    @{@"location": @"Portland, OR, USA",
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
                    @{@"location": @"Portland, OR, USA",
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
                    @{@"location": @"Portland, OR, USA",
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
                      @"finePrint": @"The posh rooms feature pillow-top mattresses, flat-screen TVs and free WiFi. Suites add sitting areas."},
                    
                    @{@"location": @"Portland, OR, USA",
                      @"hotelAddress": @"11938 NE Airport Way, Portland, OR 97220",
                      @"lat": @45.5664724,
                      @"lng": @-122.5422032,
                      @"hotelName": @"Holiday Inn Express & Suites Portland Airport",
                      @"hotelId": @"12348",
                      @"imageUrl": @"http://www.kayak.com/rimg/himg/4b/d5/b2/leonardo-1083394-WELCM_EXTR_07_S-image.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"2.0",
                      @"price": @"89",
                      @"currencyCode": @"USD",
                      @"amenities": @"Amenities include 2 eateries, an exercise room, a business center and meeting space. The property is also home to a collection of work by local Pulitzer Prize-winning photographer, David Hume Kennerly.",
                      @"description": @"Set in a 1909 landmark, this chic downtown hotel is 3 blocks from the Pioneer Square North MAX Station and 7 blocks from the Governor Tom McCall Waterfront Park. ",
                      @"finePrint": @"The posh rooms feature pillow-top mattresses, flat-screen TVs and free WiFi. Suites add sitting areas."},
                    
                    @{@"location": @"Portland, OR, USA",
                      @"hotelAddress": @"9750 NE Cascades Pkwy, Portland, OR 97220",
                      @"lat": @45.5740756,
                      @"lng": @-122.5651282,
                      @"hotelName": @"Hyatt Place Portland Airport/Cascade Station",
                      @"hotelId": @"15348",
                      @"imageUrl": @"http://s1.pclncdn.com/pclnhtlimg/images/i/10/10206505/10206505_0.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"3.0",
                      @"price": @"143",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"An 2.5-mile drive from Portland International Airport, this relaxed hotel is also 7.1 miles from downtown Portland and 10.9 miles from the Portland Art Museum.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},

                    @{@"location": @"Portland, OR, USA",
                      @"hotelAddress": @"2333 NW Vaughn St, Portland, OR 97210",
                      @"lat": @45.5372827,
                      @"lng": @-122.701858,
                      @"hotelName": @"Holiday Inn Express & Suites ",
                      @"hotelId": @"15359",
                      @"imageUrl": @"http://exp.cdn-hotels.com/hotels/1000000/790000/787900/787900/787900_272_z.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"2.0",
                      @"price": @"99",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"An 2.5-mile drive from Portland International Airport, this relaxed hotel is also 7.1 miles from downtown Portland and 10.9 miles from the Portland Art Museum.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},

                    @{@"location": @"San Francisco, CA, USA",
                      @"hotelAddress": @"500 California Street, San Francisco, CA 94104",
                      @"lat": @37.7931244,
                      @"lng": @-122.4053665,
                      @"hotelName": @"Omni San Francisco Hotel",
                      @"hotelId": @"12548",
                      @"imageUrl": @"http://r-ec.bstatic.com/images/hotel/840x460/216/21625438.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"4.0",
                      @"price": @"139",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"An 2.5-mile drive from San Francisco International Airport.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},
                    @{@"location": @"San Francisco, CA, USA",
                      @"hotelAddress": @"950 Mason St, San Francisco, CA 94108",
                      @"lat": @37.7925001,
                      @"lng": @-122.4122241,
                      @"hotelName": @"Fairmont San Francisco",
                      @"hotelId": @"12558",
                      @"imageUrl": @"http://r-ec.bstatic.com/images/hotel/840x460/553/55338486.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"5.0",
                      @"price": @"239",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"An 2.5-mile drive from San Francisco International Airport.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},

                    @{@"location": @"San Francisco, CA, USA",
                      @"hotelAddress": @"1625 Post St, San Francisco, CA 94115",
                      @"lat": @37.785495,
                      @"lng": @-122.4308205,
                      @"hotelName": @"Hotel Kabuki",
                      @"hotelId": @"12559",
                      @"imageUrl": @"http://exp.cdn-hotels.com/hotels/1000000/10000/1100/1003/1003_73_y.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"3.0",
                      @"price": @"135",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"Upscale Japanese-influenced option offering serene rooms, a garden with a koi pond & a sleek lounge.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},

                    @{@"location": @"San Francisco, CA, USA",
                      @"hotelAddress": @"943 S Van Ness Ave, San Francisco, CA 94110",
                      @"lat": @37.7580865,
                      @"lng": @-122.4187245,
                      @"hotelName": @"The Inn San Francisco",
                      @"hotelId": @"12559",
                      @"imageUrl": @"http://exp.cdn-hotels.com/hotels/2000000/1150000/1145300/1145267/1145267_9_y.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"3.0",
                      @"price": @"195",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"Antiques-filled rooms, most with private baths, with free breakfast buffet in a Victorian mansion.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},
                    
                    @{@"location": @"Los Angeles, CA, USA",
                      @"hotelAddress": @"1020 S Figueroa Street Los Angeles CA 90015",
                      @"lat": @34.044177,
                      @"lng": @-118.264245,
                      @"hotelName": @"Luxe City Center Hotel",
                      @"hotelId": @"15349",
                      @"imageUrl": @"http://aff.bstatic.com/images/hotel/max500/400/40059104.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"4.0",
                      @"price": @"206",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"An 2.5-mile drive from Portland International Airport, this relaxed hotel is also 7.1 miles from downtown Portland and 10.9 miles from the Portland Art Museum.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},
                    
                    @{@"location": @"Los Angeles, CA, USA",
                      @"hotelAddress": @"333 S Figueroa St Los Angeles CA 90071",
                      @"lat": @34.054656,
                      @"lng": @-118.255575,
                      @"hotelName": @"The LA Hotel Downtown",
                      @"hotelId": @"15350",
                      @"imageUrl": @"https://images.trvl-media.com/hotels/1000000/20000/11200/11172/11172_104_z.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"3.5",
                      @"price": @"211",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"An 2.5-mile drive from Portland International Airport, this relaxed hotel is also 7.1 miles from downtown Portland and 10.9 miles from the Portland Art Museum.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},
                    
                    @{@"location": @"Los Angeles, CA, USA",
                      @"hotelAddress": @"811 N Alvarado St, Los Angeles, CA 90026",
                      @"lat": @34.0751732,
                      @"lng": @-118.2675857,
                      @"hotelName": @"Americas Best Value Inn",
                      @"hotelId": @"15352",
                      @"imageUrl": @"http://exp.cdn-hotels.com/hotels/2000000/1190000/1189600/1189511/1189511_96_z.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"2.0",
                      @"price": @"75",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"Low-rise budget hotel offering cable TV, microwaves & minifridges, plus continental breakfast.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},

                    @{@"location": @"Los Angeles, CA, USA",
                      @"hotelAddress": @"711 N Main St, Los Angeles, CA 90012",
                      @"lat": @34.0588158,
                      @"lng": @-118.239854,
                      @"hotelName": @"Metro Plaza Hotel",
                      @"hotelId": @"15357",
                      @"imageUrl": @"http://exp.cdn-hotels.com/hotels/1000000/30000/26200/26164/26164_20_z.jpg",
                      @"starsUrl": @"",
                      @"starRating": @"2.0",
                      @"price": @"95",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"Simple rooms & suites (some with kitchens), plus a gym, free continental breakfast & WiFi.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."},
                    
                    @{@"location": @"Los Angeles, CA, USA",
                      @"hotelAddress": @"1401 S Oak Knoll Ave Pasadena CA 91106",
                      @"lat": @34.121384,
                      @"lng": @-118.133324,
                      @"hotelName": @"Langham Huntington, Pasadena, Los Angeles",
                      @"hotelId": @"15351",
                      @"imageUrl": @"https://www.kayak.ie/rimg/himg/1a/05/90/leonardo-1073534-Porte_Cochere_S-image.jpg?width=502&height=374",
                      @"starsUrl": @"",
                      @"starRating": @"3.5",
                      @"price": @"249",
                      @"currencyCode": @"USD",
                      @"amenities": @"Complimentary amenities include breakfast, parking, and an airport shuttle. There's also an indoor pool and whirlpool tub, plus a 24-hour fitness center.",
                      @"description": @"An 2.5-mile drive from Portland International Airport, this relaxed hotel is also 7.1 miles from downtown Portland and 10.9 miles from the Portland Art Museum.",
                      @"finePrint": @"Featuring free Wi-Fi and work desks, the modern rooms also have flat-screen TVs, minifridges and pull-out sofas. Upgraded rooms add separate living areas."}

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
//    [self addTripVersion2];
    [self addTripVersion3];
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
    [self addTripUnitsV4];
}

- (void) addTripUnitsV4 {
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
        
        PFObject *tripUnitObject = [PFObject objectWithClassName:@"TripUnitV4"];
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

// One to Many relations using Pointers
- (void) addTripVersion2 {
    self.trip = @{@"tripId": @"12345",
                  @"tripName": @"Trip from Seattle WA to Los Angelos CA 20151201"
                  };
    
    self.tripUnits = @[
                       
                       @{
                         @"hotelAddress": @"400 SW Broadway, Portland, OR 97205",
                         @"hotelName": @"Hotel Lucia",
                         @"location": @"Portland, OR",
                         @"checkIn": @"2015-12-01",
                         @"checkOut": @"2015-12-03"
                         },
                       @{
                         @"hotelAddress": @"55 Cyril Magnin St, San Francisco, CA 94102",
                         @"hotelName": @"Parc 55",
                         @"location": @"San Francisco, CA",
                         @"checkIn": @"2015-12-04",
                         @"checkOut": @"2015-12-07"
                         }
                       
                       ];

    
    PFObject *tripObject = [PFObject objectWithClassName:@"TripV2"];
    tripObject[@"tripId"] = self.trip[@"tripId"];
    tripObject[@"tripName"] = self.trip[@"tripName"];
    
    [tripObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Trip has been saved");
            
            for (NSDictionary *dictionary in self.tripUnits) {
                
                PFObject *tripUnitObject = [PFObject objectWithClassName:@"TripUnitV2"];
                tripUnitObject[@"hotelAddress"] = dictionary[@"hotelAddress"];
                tripUnitObject[@"location"] = dictionary[@"location"];
                tripUnitObject[@"checkIn"] = dictionary[@"checkIn"];
                tripUnitObject[@"checkOut"] = dictionary[@"checkOut"];
                [tripUnitObject setObject:tripObject forKey:@"forTrip"];
                
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
            
            
        } else {
            // There was a problem, check error.description
            NSLog(@"Error in saving Trip");
        }
    }];
    
}

// One to Many relations using arrays
- (void) addTripVersion3 {
    self.trip = @{@"tripId": @"12345",
                  @"tripName": @"Trip from Seattle WA to Los Angelos CA 20151201"
                  };
    
    self.tripLocations = @[
                          @{
                            @"location": @"Portland, OR"
                           },
                          @{
                            @"location": @"San Francisco, CA"
                           }
                          ];

    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dictionary in self.tripLocations) {
        PFObject *tripLocationObject = [PFObject objectWithClassName:@"TripLocationV3"];
        tripLocationObject[@"location"] = dictionary[@"location"];
        
        [array addObject:tripLocationObject];
    }
    
    PFObject *tripObject = [PFObject objectWithClassName:@"TripV3"];
    tripObject[@"tripId"] = self.trip[@"tripId"];
    tripObject[@"tripName"] = self.trip[@"tripName"];
    [tripObject setObject:array forKey:@"locationList"];
    
    [tripObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Trip has been saved");
            
        } else {
            // There was a problem, check error.description
            NSLog(@"Error in saving Trip");
        }
    }];


}



- (IBAction)queryTripButtonTapped:(UIButton *)sender {
    NSLog(@"Query Trip");
//    [self queryTripV2];
    [self queryTripV3];
    [self nowString];
}

// one to many using pointers
- (void) queryTripV2 {
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"tripId" equalTo:@"151205230028"];
    [query includeKey:@"tripLocations"];
    NSArray* tripArray = [query findObjects];
    for (PFObject *object in tripArray) {
        NSLog(@"Debug");
    }
    NSLog(@"Debug Here");
}

// one to many using arrays
- (void) queryTripV3 {
    PFQuery *query = [PFQuery queryWithClassName:@"TripV3"];
//    [query whereKey:@"tripId" equalTo:@"12345"];
    NSArray* tripArray = [query findObjects];
    for (PFObject *object in tripArray) {
        NSString *tripName = [object objectForKey:@"tripName"];
        NSLog(@"Debug");
        
//        NSString *someValue = [pfObject objectForKey:@"someKey"];
//        //or if it's a number
//        NSNumber *someNumber = [pfObject objectForKey:@"someOtherKey"];
    }

    NSLog(@"Debug Here");
    
}

// used for generating trip id
- (void) nowString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyMMddHHmmss"];
    
    NSDate *date = [NSDate date];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:date];
    NSLog(@"formattedDateString: %@", formattedDateString);
}



@end
