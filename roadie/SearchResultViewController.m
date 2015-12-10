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
#import "MDDirectionService.h"
#import <GoogleMaps/GoogleMaps.h>
#import "City.h"
#import "UICityButton.h"
#import "DRPageScrollView.h"
#import "Parse.h"

@interface SearchResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchResultViewController {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
    UIScrollView *cityChooserView_;
}

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
    self.tableView.bounces = NO;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    cityChooserView_ = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 30.0)];
    cityChooserView_.backgroundColor = [UIColor grayColor];
    
    // Init cities (need to be set dynamically later)
    City *allCities = [City new];
    allCities.hotels = self.hotels;
    allCities.name = @"All Cities";
    allCities.location = nil;
    allCities.lat = 45.5425353;
    allCities.lng = -122.7042106;
    
    City *portland = [City new];
    portland.hotels = self.hotels;
    portland.name = @"Portland";
    portland.location = @"Portland, OR, USA";
    portland.lat = 45.5263883;
    portland.lng = -122.7244615;
    
    City *sanfrancisco = [City new];
    sanfrancisco.hotels = self.hotels;
    sanfrancisco.name = @"Sanfrancisco";
    sanfrancisco.location = @"San Francisco, CA, USA";
    sanfrancisco.lat = 37.7559489;
    sanfrancisco.lng = -122.4639522;
    
    City *losangeles = [City new];
    losangeles.hotels = self.hotels;
    losangeles.name = @"Los Angeles";
    losangeles.location = @"Los Angeles, CA, USA";
    losangeles.lat = 34.0412372;
    losangeles.lng = -118.2506402;
    
    // City Chooser View
    [self addCityButton:allCities andRect:CGRectMake(0.0, 0.0, 100.0, 30.0)];
    [self addCityButton:portland andRect:CGRectMake(110.0, 0.0, 80.0, 30.0)];
    [self addCityButton:sanfrancisco andRect:CGRectMake(200.0, 0.0, 120.0, 30.0)];
    [self addCityButton:losangeles andRect:CGRectMake(330.0, 0.0, 110.0, 30.0)];
    
    cityChooserView_.contentSize = CGSizeMake(450.0, 30.0);
    [cityChooserView_ setShowsHorizontalScrollIndicator:NO];
    [cityChooserView_ setShowsVerticalScrollIndicator:NO];
    
    // Init Map View
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:45.5263883
                                                            longitude:-122.7042106
                                                                 zoom:4];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0.0, cityChooserView_.frame.size.height, screenWidth, screenHeight/2) camera:camera];
    
    mapView_.camera = camera;
    mapView_.myLocationEnabled = YES;
    
    for (int i = 0; i < self.hotels.count; i++) {
        Hotel *hotel = self.hotels[i];
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(hotel.lat, hotel.lng);
        marker.title = hotel.hotelName;
        marker.snippet = hotel.hotelAddress;
        marker.map = mapView_;
    }
    
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    CLLocationCoordinate2D seattleSpot = CLLocationCoordinate2DMake(47.6088246,-122.337866);
    [self mapView:mapView_ addSpot:seattleSpot];
    
    CLLocationCoordinate2D losangelesSpot = CLLocationCoordinate2DMake(34.0412372,-118.2506402);
    [self mapView:mapView_ addSpot:losangelesSpot];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, mapView_.frame.size.height + cityChooserView_.frame.size.height)];
    [headerView addSubview:cityChooserView_];
    [headerView addSubview:mapView_];
    self.tableView.tableHeaderView = headerView;
}

- (void)addCityButton:(City*)city andRect:(CGRect) rect {
    UICityButton *button = [UICityButton buttonWithType:UIButtonTypeCustom];
    button.city = city;
    [button addTarget:self action:@selector(onClickCities:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:city.name forState:UIControlStateNormal];
    button.frame = rect;
    [cityChooserView_ addSubview:button];
}

- (void)onClickCities:(id)sender {
    UICityButton *cityButton = (UICityButton*)sender;
    City *city = cityButton.city;
    
    float zoomLevel = 10;
    if ([city.name isEqualToString:@"All Cities"]) {
        zoomLevel = 4;
    }
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:city.lat
                                                            longitude:city.lng
                                                                 zoom:zoomLevel];
    mapView_.camera = camera;
    
    [self filterCityByLocation:city];
}

- (void) filterCityByLocation: (City*) city {
    PFQuery *query = [PFQuery queryWithClassName:@"Hotel"];
    if (city.location != nil) {
        [query whereKey:@"location" equalTo:city.location];
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved hotels");
            self.hotels = [self hotelsWithArray:objects];
            
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

- (NSArray *) hotelsWithArray: (NSArray *)array {
    NSMutableArray *hotels = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [hotels addObject:[[Hotel alloc] initWithDictionary:dictionary]];
    }
    
    return hotels;
}

- (void)mapView:(GMSMapView *)mapView addSpot:
(CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(coordinate.latitude,
                                                                 coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = mapView;
    [waypoints_ addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];
    [waypointStrings_ addObject:positionString];
    if([waypoints_ count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        MDDirectionService *mds=[[MDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}
- (void)addDirections:(NSDictionary *)json {
    
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;
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
    NSLog(@"searchWithLocation Not implemented");
}

@end
