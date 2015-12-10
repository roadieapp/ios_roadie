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
#import "StayPlaceCell.h"
#import "SearchResultViewController.h"
#import "Hotel.h"
#import "Parse.h"
@import GoogleMaps;
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import "DatePickerCell.h"
#import "Trip.h"

static NSString *kDatePickerCellID = @"datePickerCell";

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, StayPlaceCellDelegate, GMSAutocompleteViewControllerDelegate, StayPlaceCellDestinationDelegate, StartTimeCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger numOfStayPlaces;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *pickedDate;
//@property (weak, nonatomic) IBOutlet UIButton *mybutton;
@property (nonatomic, strong) UITextField *currentTextField;

// Array of Dictionary
@property (nonatomic, strong) NSArray *searchResults;

@property (nonatomic) BOOL datePickerIsShowing;


@end

@implementation HomeViewController {
    GMSPlacesClient *_placesClient;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _placesClient = [[GMSPlacesClient alloc] init];
    [self setUpNavigationBar];
    [self customizeLeftNavBarButtons];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"StayPlaceCell" bundle:nil] forCellReuseIdentifier:@"StayPlaceCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DatePickerCell" bundle:nil] forCellReuseIdentifier:@"DatePickerCell"];
    self.tableView.allowsSelection = NO;
}

- (void)onDatePickerValueChanged {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.pickedDate = formattedDate;
    [self.tableView reloadData];
}

- (void)stayPlaceCell:(StayPlaceCell *)cell click:(int)buttonType{
    if (buttonType == 0) {
        self.numOfStayPlaces = self.numOfStayPlaces + 1;
    } else {
        self.numOfStayPlaces = self.numOfStayPlaces - 1;
    }
    [self.tableView reloadData];
}

- (void)stayPlaceCell:(StayPlaceCell *)cell {
    self.currentTextField = cell.destinationTextField;
    [self presentPlaceAutoComplete];
}

- (void)startTimeCell:(StartTimeCell *)cell {
    if ([self.datePicker isHidden]) {
        [self showDatePicker];
    } else {
        [self hideDatePicker];
    }
}

- (void)presentPlaceAutoComplete {
    GMSAutocompleteViewController *acController = [[GMSAutocompleteViewController alloc] init];
    acController.delegate = self;
    [self presentViewController:acController animated:YES completion:nil];
}

// Handle the user's selection.
- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    // Do something with the selected place.
    self.currentTextField.text = place.formattedAddress;
}

- (void)viewController:(GMSAutocompleteViewController *)viewController didAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

// User canceled the operation.
- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    NSLog(@"Error: %@", [error description]);
}

- (void)showDatePicker {
    self.datePickerIsShowing = YES;
    self.datePicker.hidden = NO;
    self.datePicker.alpha = 0.0f;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.datePicker.alpha = 1.0f;
    }];
}

- (void)hideDatePicker {
    self.datePickerIsShowing = NO;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.datePicker.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         self.datePicker.hidden = YES;
                     }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numOfStayPlaces + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        StayPlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StayPlaceCell"];
        [cell.iconImage setImage:[UIImage imageNamed:@"departure.png"]];
        [cell.destinationTextField setPlaceholder:@"Choose your departure place"];
        cell.delegate = self;
        cell.destinationDelegate = self;
        cell.removeButton.hidden = YES;
        if (self.numOfStayPlaces == 0) {
            cell.addButton.hidden = NO;
        } else {
            cell.addButton.hidden = YES;
        }
        return cell;
    } else if (indexPath.row == self.numOfStayPlaces + 1) {
        StayPlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StayPlaceCell"];
        [cell.iconImage setImage:[UIImage imageNamed:@"destination.png"]];
        [cell.destinationTextField setPlaceholder:@"Choose your destination"];
        cell.destinationDelegate = self;
        cell.addButton.hidden = YES;
        cell.removeButton.hidden = YES;
        return cell;
    } else if (indexPath.row == self.numOfStayPlaces + 2) {
        StartTimeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StartTimeCell"];
        [cell.timeButton setTitle:[NSString stringWithFormat:@"Leave by %@", self.pickedDate] forState:UIControlStateNormal];
        [cell.timeButton sizeToFit];
        [[cell.timeButton layer] setBorderWidth:0.6f];
        [[cell.timeButton layer] setCornerRadius:5.0f];
        [[cell.timeButton layer] setBorderColor:[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor];
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == self.numOfStayPlaces + 3) {
        DatePickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        self.datePicker = cell.datePicker;
        [self.datePicker addTarget:self action:@selector(onDatePickerValueChanged) forControlEvents:UIControlEventValueChanged];
        if (!self.datePickerIsShowing) {
            self.datePicker.alpha = 0.0f;
            self.datePicker.hidden = YES;
        }
        return cell;
    } else {
        StayPlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StayPlaceCell"];
        [cell.iconImage setImage:[UIImage imageNamed:@"stayat.png"]];
        [cell.destinationTextField setPlaceholder:@"Choose a place to stay"];
        cell.delegate = self;
        cell.destinationDelegate = self;
        cell.addButton.hidden = YES;
        cell.removeButton.hidden = YES;
        if (indexPath.row == self.numOfStayPlaces) {
            cell.addButton.hidden = NO;
            cell.removeButton.hidden = NO;
        }
        return cell;
    }
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
    self.datePickerIsShowing = NO;
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

- (void)customizeLeftNavBarButtons {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"New"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onNewButton)];
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)customizeRightNavBarButtons {
    UIBarButtonItem *barButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Next"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onNextButton)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void) onNewButton {
    [Trip clear];
    for (int i = 0; i <= self.numOfStayPlaces + 1; i++) {
        StayPlaceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.destinationTextField.text = @"";
    }
    
    [self.tableView reloadData];

}

- (void) onNextButton {
    if ([Trip currentTrip] == nil) {
        [Trip createTrip];
        [self createTripData];
        NSLog(@"%@", [Trip currentTrip].tripId);
    } else {
        [self updateTripData];
    }
    
    PFQuery *query = [PFQuery queryWithClassName:@"Hotel"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved hotels");
            // Do something with the found objects
            
            self.searchResults = objects;
            [self displaySearchResult];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (NSArray *) findTripLocations {
    NSMutableArray *locations = [[NSMutableArray alloc]init];
    for (int i = 0; i <= self.numOfStayPlaces + 1; i++) {
        StayPlaceCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        NSDictionary *location = @{
                                   @"location" : cell.destinationTextField.text
                                   };
        [locations addObject:location];
    }

    return locations;
}

- (void) createTripData {
    NSArray *locations = [self findTripLocations];
    PFObject *tripObject = [PFObject objectWithClassName:@"Trip"];
    tripObject[@"tripId"] = [Trip currentTrip].tripId;
    tripObject[@"tripName"] = @"My Trip";
    tripObject[@"tripStartTime"] = self.pickedDate;
    tripObject[@"tripLocations"] = locations;
    tripObject[@"booked"] = [NSNumber numberWithBool:NO];
    
    [tripObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            NSLog(@"Trip has been saved");
            
        } else {
            // There was a problem, check error.description
            NSLog(@"Error in saving Trip");
        }
    }];
}

- (void) updateTripData {
    NSLog(@"updateTripData");
    PFQuery *query = [PFQuery queryWithClassName:@"Trip"];
    [query whereKey:@"tripId" equalTo:[Trip currentTrip].tripId];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Should be one object only.
            PFObject *tripObject = [objects lastObject];
            
            NSArray *locations = [self findTripLocations];
            tripObject[@"tripStartTime"] = self.pickedDate;
            tripObject[@"tripLocations"] = locations;
            
            [tripObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    // The object has been updated.
                    NSLog(@"Trip has been updated");
                    
                } else {
                    // There was a problem, check error.description
                    NSLog(@"Error in updating Trip");
                }
            }];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) displaySearchResult {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
