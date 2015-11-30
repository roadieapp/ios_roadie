//
//  HomeViewController.m
//  roadie
//
//  Created by Xin Suo on 11/18/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "HomeViewController.h"
#import "Constants.h"
#import "StartTimeCell.h"
#import "DestinationCell.h"
#import "StayPlaceCell.h"
#import "SearchResultViewController.h"
#import "Hotel.h"
@import GoogleMaps;

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, DestinationCellDelegate, StayPlaceCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger numOfStayPlaces;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *pickedDate;
//@property (weak, nonatomic) IBOutlet UIButton *mybutton;

// Array of Dictionary
@property (nonatomic, strong) NSArray *searchResults;

@end

@implementation HomeViewController {
    GMSPlacesClient *_placesClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _placesClient = [[GMSPlacesClient alloc] init];
    [self setUpNavigationBar];
    [self customizeRightNavBarButtons];
    [self setUpInitialData];
    [self setUpTable];
}

- (void)setUpTable {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"StartTimeCell" bundle:nil] forCellReuseIdentifier:@"StartTimeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DestinationCell" bundle:nil] forCellReuseIdentifier:@"DestinationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"StayPlaceCell" bundle:nil] forCellReuseIdentifier:@"StayPlaceCell"];
    self.tableView.allowsSelection = NO;
}

- (void)stayPlaceCell:(StayPlaceCell *)cell {
    self.numOfStayPlaces = self.numOfStayPlaces + 1;
    [self.tableView reloadData];
}

- (void)destinationCellDelegate {
    // Place autocomplete
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numOfStayPlaces + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        StartTimeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StartTimeCell"];
        [cell.timeButton setTitle:self.pickedDate forState:UIControlStateNormal];
        return cell;
    } else if (indexPath.row == 1) {
        DestinationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DestinationCell"];
        cell.label.text = @"Departure";
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == self.numOfStayPlaces + 2) {
        DestinationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DestinationCell"];
        cell.label.text = @"Arrival      ";
        cell.delegate = self;
        return cell;
    } else {
        StayPlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StayPlaceCell"];
        cell.delegate = self;
        return cell;
    }
}

- (IBAction)onDatePicked:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.pickedDate = formattedDate;
    [self.tableView reloadData];
}

- (NSString *)getCurrentDateString {
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    return newDateString;
}

- (void)setUpInitialData {
    self.numOfStayPlaces = 1;
    self.pickedDate = [self getCurrentDateString];
}

- (void)setUpNavigationBar {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // set background color
    [navigationBar setBarTintColor:[[Constants sharedInstance] themeColor]];
    [navigationBar setTranslucent:NO];
    // remove bottom line
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[[UIImage alloc] init]];
}

- (void)customizeRightNavBarButtons {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Search"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onSearchButton)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void) onSearchButton {
    [self initSearchResult];
    NSArray *hotels = [self hotelsWithArray:self.searchResults];
    
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    resultVC.hotels = hotels;
    
    [self.navigationController pushViewController:resultVC animated:YES];

}

- (NSArray *) hotelsWithArray: (NSArray *)array {
    NSMutableArray *hotels = [NSMutableArray array];
    
    for (NSDictionary *dictionary in array) {
        [hotels addObject:[[Hotel alloc] initWithDictionary:dictionary]];
    }
    
    return hotels;
}

- (void) initSearchResult {
    self.searchResults = @[
                           @{@"location": @"Portland, OR",
                             @"hotelAddress": @"400 SW Broadway, Portland, OR 97205",
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
