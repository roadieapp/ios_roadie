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

@interface SearchResultViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SearchResultViewController {
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
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
    
    // Init Map View
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:45.5263883
                                                            longitude:-122.7042106
                                                                 zoom:6];
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
    
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    CLLocationCoordinate2D seattle = CLLocationCoordinate2DMake(47.6149942,-122.4759891);
    [self mapView:self.mapView addSpot:seattle];
    
    CLLocationCoordinate2D sanfrancisco = CLLocationCoordinate2DMake(37.757815,-122.50764);
    [self mapView:self.mapView addSpot:sanfrancisco];
}

- (void)mapView:(GMSMapView *)mapView addSpot:
(CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(coordinate.latitude,
                                                                 coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = self.mapView;
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
    polyline.map = self.mapView;
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
