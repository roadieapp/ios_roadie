//
//  TripDetailController.m
//  roadie
//
//  Created by Robin Wu on 11/26/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "TripDetailController.h"
#import "TripCell.h"

@interface TripDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *trip;

@end

@implementation TripDetailController

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

@end
