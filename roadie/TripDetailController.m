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
#import "Parse.h"
#import "Trip.h"

@interface TripDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *trip;

@property (nonatomic, strong) NSString *tripStartTime;

@end

@implementation TripDetailController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
//    if (self) {
//        [self initTrip];
//    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavigationBar];
    [self customizeRightNavBarButtons];
    [self setUpTableView];
    [self refreshData];
}

- (void) refreshData {
    NSLog(@"refresh data");
    NSString *currentTripId = [[Trip currentTrip] tripId];
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"tripId" equalTo:currentTripId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error == nil) {
            // Should be one object only.
            NSLog(@"Debug here");
            
            // tripStartTime
            // tripLocations
            NSDictionary *dictionary = [objects lastObject];
            self.tripStartTime = dictionary[@"tripStartTime"];
            NSLog(@"Trip Start Time: %@", self.tripStartTime);
            NSArray *array1 = dictionary[@"tripLocations"];
            for (NSDictionary *dict1 in array1) {
                NSLog(@"Location: %@", dict1[@"location"]);
            }
            NSLog(@"trip id: %@", dictionary[@"tripId"]);
            
            
            PFQuery *tripUnitQuery = [PFQuery queryWithClassName:@"TripUnit"];
            [tripUnitQuery whereKey:@"tripId" equalTo:currentTripId];
            [tripUnitQuery orderByAscending:@"checkIn"];
            
            [tripUnitQuery findObjectsInBackgroundWithBlock:^(NSArray *objects1, NSError *error1) {
                if (error1 == nil) {

                    NSLog(@"Debug here");
                    for (NSDictionary *dict2 in objects1) {
                        NSLog(@"Location: %@", dict2[@"location"]);
                        NSLog(@"Hotel Name: %@", dict2[@"hotelName"]);
                        NSLog(@"Hotel Address: %@", dict2[@"hotelAddress"]);
                        NSLog(@"Check In: %@", dict2[@"hotelCheckIn"]);
                        NSLog(@"Check Out: %@", dict2[@"hotelCheckOut"]);
                        NSLog(@"Trip ID: %@", dict2[@"tripId"]);
                    };
                    
//                    [self.tableView reloadData];
                } else {
                    NSLog(@"Error 1");
                }
            }];
        } else {
            NSLog(@"Error");
        }
    }];

    
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

- (void)customizeRightNavBarButtons {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"History"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onHistoryButton)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
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

- (void) onHistoryButton {
    NSLog(@"on History");
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
