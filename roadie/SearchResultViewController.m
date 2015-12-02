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
    NSLog(@"searchWithLocation Not implemented");
}

@end
