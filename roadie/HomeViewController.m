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
@import GoogleMaps;

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, DestinationCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger numOfStayPlaces;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *pickedDate;
@property (weak, nonatomic) IBOutlet UIButton *mybutton;

@end

@implementation HomeViewController {
    GMSPlacesClient *_placesClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _placesClient = [[GMSPlacesClient alloc] init];
    [self setUpNavigationBar];
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
        NSLog(@"%@", self.pickedDate);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
