//
//  TripDetailController.m
//  roadie
//
//  Created by Robin Wu on 11/26/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "TripDetailController.h"
#import "TripCell.h"
#import "TripUnit.h"

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
    
    [self setUpTableView];
}

- (void)setUpTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TripCell" bundle:nil] forCellReuseIdentifier:@"TripCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TripCell"];
    [cell setTripUnit:self.trip[indexPath.row]];
    
    return cell;
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
