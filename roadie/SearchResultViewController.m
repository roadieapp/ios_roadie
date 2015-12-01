//
//  SearchResultViewController.m
//  roadie
//
//  Created by David Wang on 11/22/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "SearchResultViewController.h"
#import "HotelViewCell.h"
#import "HotelDetailController.h"
@import GoogleMaps;

@interface SearchResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Search Results";
    
    // Init table View
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"HotelViewCell" bundle:nil] forCellReuseIdentifier:@"HotelViewCell"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    // Init Map View
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:45.5263883
                                                            longitude:-122.7042106
                                                                 zoom:13];
    self.mapView.camera = camera;
    self.mapView.myLocationEnabled = YES;
    
    for (int i = 0; i < self.hotels.count; i++) {
        Hotel *hotel = self.hotels[i];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(hotel.lat, hotel.lng);
        marker.title = hotel.hotelName;
        marker.snippet = hotel.hotelAddress;
        marker.map = self.mapView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.hotels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotelViewCell"];
    [cell setHotel:self.hotels[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HotelDetailController *vc = [[HotelDetailController alloc] init];
    vc.hotel = self.hotels[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchWithLocation {
    // Call the client to get the search result, save the search result into the hotels;
   NSArray *hotelArray = @[
      @{@"location": @"Portland, OR",
        @"hotelAddress": @"400 SW Broadway, Portland, OR 97205",
        @"lat": @45.5210634,
        @"lng": @-122.6805098,
        @"hotelName": @"Hotel Lucia",
        @"hotelId": @"12345",
        @"imageUrl": @"http://exp.cdn-hotels.com/hotels/1000000/20000/16000/15988/15988_118_z.jpg",
        @"starsUrl": @"",
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
        @"price": @"253",
        @"currencyCode": @"USD",
        @"amenities": @"Amenities include 2 eateries, an exercise room, a business center and meeting space. The property is also home to a collection of work by local Pulitzer Prize-winning photographer, David Hume Kennerly.",
        @"description": @"Set in a 1909 landmark, this chic downtown hotel is 3 blocks from the Pioneer Square North MAX Station and 7 blocks from the Governor Tom McCall Waterfront Park. ",
        @"finePrint": @"The posh rooms feature pillow-top mattresses, flat-screen TVs and free WiFi. Suites add sitting areas."}
      ];
    
    self.hotels = [self hotelsWithArray: hotelArray];
    // update the UI
    
//    for (int i = 0; i < self.hotels.count; i++) {
//        Hotel *hotel = self.hotels[i];
//        CLLocationCoordinate2D position = CLLocationCoordinate2DMake(hotel.lat , hotel.lng);
//        GMSMarker *london = [GMSMarker markerWithPosition:position];
////        london.flat = YES;
//        london.map = self.mapView;
//    }
    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(47.5980774, -122.3306292);
//    marker.title = @"Groupon, Seattle";
//    marker.snippet = @"USA";
//    marker.map = self.mapView;
}

- (NSArray *) hotelsWithArray: (NSArray *)array {
    NSMutableArray *hotels = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [hotels addObject:[[Hotel alloc] initWithDictionary:dictionary]];
    }
    
    return hotels;
}

@end
