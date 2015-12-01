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
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = @"Home";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];

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
    SearchResultViewController *resultVC = [[SearchResultViewController alloc] init];
    [resultVC searchWithLocation];
    
    [self.navigationController pushViewController:resultVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
