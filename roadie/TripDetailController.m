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

@property (weak, nonatomic) IBOutlet UIButton *bookButton;

// user can pull to refresh the trip information
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TripDetailController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // initial state
    self.bookButton.hidden = YES;
    
    [self setUpNavigationBar];
    [self customizeRightNavBarButtons];
//    [self customizeBookButton];
    [self setUpTableView];
    [self setUpRefreshControl];
    [self refreshData];
}

- (void) onRefresh {
    NSLog(@"onRefresh");
    
    if ([Trip currentTrip] == nil) {
        NSLog(@"The current trip is not created yet");
        [self.refreshControl endRefreshing];
        return;
    }
    
    NSString *currentTripId = [[Trip currentTrip] tripId];
    NSMutableArray *tripUnits = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"tripId" equalTo:currentTripId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Should be one object only.
            
            NSDictionary *dictionary = [objects lastObject];
            self.tripStartTime = dictionary[@"tripStartTime"];
            
            NSNumber *bookedInfo = dictionary[@"booked"];
            self.bookButton.hidden =  [bookedInfo boolValue];
            
            NSArray *locations = dictionary[@"tripLocations"];
            NSMutableDictionary *departDict = [NSMutableDictionary dictionaryWithDictionary:[locations firstObject]];
            [departDict setValue:self.tripStartTime forKey:@"tripStartTime"];
            [tripUnits addObject:departDict];
            
            PFQuery *tripUnitQuery = [PFQuery queryWithClassName:@"TripUnit"];
            [tripUnitQuery whereKey:@"tripId" equalTo:currentTripId];
            [tripUnitQuery orderByAscending:@"checkIn"];
            
            [tripUnitQuery findObjectsInBackgroundWithBlock:^(NSArray *objects1, NSError *error1) {
                if (!error1) {
                    
                    [tripUnits addObjectsFromArray:objects1];
                    [tripUnits addObject:[locations lastObject]];
                    
                    self.trip = [TripUnit tripWithArray:tripUnits];
                    
                    [self.tableView reloadData];
                } else {
                    NSLog(@"Error: %@ %@", error1, [error1 userInfo]);
                }
                [self.refreshControl endRefreshing];
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [self.refreshControl endRefreshing];
        }
    }];
}

- (void) refreshData {
    NSLog(@"refresh data");

    if ([Trip currentTrip] == nil) {
        NSLog(@"The current trip is not created yet");
        return;
    }
    
    NSString *currentTripId = [[Trip currentTrip] tripId];
    NSMutableArray *tripUnits = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"tripId" equalTo:currentTripId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Should be one object only.
            
            NSDictionary *dictionary = [objects lastObject];
            self.tripStartTime = dictionary[@"tripStartTime"];
            
            NSNumber *bookedInfo = dictionary[@"booked"];
            self.bookButton.hidden =  [bookedInfo boolValue];
            
            NSArray *locations = dictionary[@"tripLocations"];
            NSMutableDictionary *departDict = [NSMutableDictionary dictionaryWithDictionary:[locations firstObject]];
            [departDict setValue:self.tripStartTime forKey:@"tripStartTime"];
            [tripUnits addObject:departDict];
            
            PFQuery *tripUnitQuery = [PFQuery queryWithClassName:@"TripUnit"];
            [tripUnitQuery whereKey:@"tripId" equalTo:currentTripId];
            [tripUnitQuery orderByAscending:@"checkIn"];
            
            [tripUnitQuery findObjectsInBackgroundWithBlock:^(NSArray *objects1, NSError *error1) {
                if (!error1) {

                    [tripUnits addObjectsFromArray:objects1];
                    [tripUnits addObject:[locations lastObject]];
                    
                    self.trip = [TripUnit tripWithArray:tripUnits];
                    
                    [self.tableView reloadData];
                } else {
                    NSLog(@"Error: %@ %@", error1, [error1 userInfo]);
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
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

- (void)setUpRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void) customizeBookButton {
    UIImage *image = [[UIImage imageNamed:@"book"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.bookButton setImage:image forState:UIControlStateNormal];
    self.bookButton.tintColor = [[Constants sharedInstance] themeColor];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)onBookButtonTapped:(id)sender {
    [self tripBookedNotification];
    self.bookButton.hidden = YES;
    [self bookTrip];
}

- (void) tripBookedNotification {
    NSString *message = @"Trip is booked!";
    
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    int duration = 1; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void) bookTrip {
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"tripId" equalTo:[[Trip currentTrip] tripId]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * myTrip, NSError *error) {
        if (!error) {
            // Found UserStats
            [myTrip setObject:[NSNumber numberWithBool:YES] forKey:@"booked"];
            
            // Save
            [myTrip saveInBackground];
        } else {
            // Did not find any Trip for the current user
            NSLog(@"Error: %@", error);
        }
    }];
}

// NOT used, for reference only
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
