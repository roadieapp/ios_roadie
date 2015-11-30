//
//  TripDetailController.m
//  roadie
//
//  Created by Robin Wu on 11/26/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "TripDetailController.h"
#import "TripCell.h"
#import "TripHeaderCell.h"
#import "TripUnit.h"
#import "Constants.h"

@interface TripDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *trip;

@end

@implementation TripDetailController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self initTrip];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    [self setUpTableView];
}

- (void)setUpNavigationBar {
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // set background color
    [navigationBar setBarTintColor:[[Constants sharedInstance] themeColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = @"My Trip";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    [navigationBar setTranslucent:NO];
    // remove bottom line
    [navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[[UIImage alloc] init]];
}


- (void)setUpTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TripCell" bundle:nil] forCellReuseIdentifier:@"TripCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TripHeaderCell" bundle:nil] forCellReuseIdentifier:@"TripHeaderCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TripHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TripHeaderCell"];
        [cell setTripUnit:self.trip[indexPath.row] withHeader:YES];
        return cell;
    } else if (indexPath.row == self.trip.count - 1) {
        TripHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TripHeaderCell"];
        [cell setTripUnit:self.trip[indexPath.row] withHeader:NO];
        return cell;
    } else {
        TripCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TripCell"];
        [cell setTripUnit:self.trip[indexPath.row]];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.trip.count;
}

- (void) initTrip {
    NSArray *tripInput = @[
                  @{@"location": @"Seattle, WA",
                    @"hotelName": @"", @"hotelAddress": @"",
                    @"hotelCheckIn": @"", @"hotelCheckOut": @""},
                  @{@"location": @"Portland, OR",
                    @"hotelName": @"Hotel Lucia", @"hotelAddress": @"400 SW Broadway, Portland, OR 97205",
                    @"hotelCheckIn": @"2015-12-02", @"hotelCheckOut": @"2015-12-04"},
                  @{@"location": @"San Francisco, CA",
                    @"hotelName": @"Parc 55", @"hotelAddress": @"55 Cyril Magnin St, San Francisco, CA 94102",
                    @"hotelCheckIn": @"2015-12-04", @"hotelCheckOut": @"2015012007"},
                  @{@"location": @"Los Angeles, CA",
                    @"hotelName": @"", @"hotelAddress": @"",
                    @"hotelCheckIn": @"", @"hotelCheckOut": @""}
                 ];
    
    self.trip = [TripUnit tripWithArray:tripInput];
}


@end
