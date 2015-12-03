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

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, StayPlaceCellDelegate, GMSAutocompleteViewControllerDelegate, StayPlaceCellDestinationDelegate, StartTimeCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger numOfStayPlaces;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSString *pickedDate;
//@property (weak, nonatomic) IBOutlet UIButton *mybutton;
@property (nonatomic, strong) UITextField *currentTextField;

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
    [self.tableView registerNib:[UINib nibWithNibName:@"StayPlaceCell" bundle:nil] forCellReuseIdentifier:@"StayPlaceCell"];
    self.tableView.allowsSelection = NO;
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
        [self.datePicker setHidden:NO];
    } else {
        [self.datePicker setHidden:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numOfStayPlaces + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        StayPlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StayPlaceCell"];
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
    } else {
        StayPlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"StayPlaceCell"];
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
    [self.datePicker setHidden:YES];
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
//    [self initSearchResult];
//    [self displaySearchResult];
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

// Note, this is used for populate data based on the array of dictionary.
// Please DO NOT call it.
- (void) saveHotelData {
    // the array can be changed to another array for data population only.
    for (NSDictionary *dictionary in self.searchResults) {
        PFObject *hotelObject = [PFObject objectWithClassName:@"Hotel"];
        hotelObject[@"location"] = dictionary[@"location"];
        hotelObject[@"hotelAddress"] = dictionary[@"hotelAddress"];
        hotelObject[@"hotelName"] = dictionary[@"hotelName"];
        hotelObject[@"hotelId"] = dictionary[@"hotelId"];
        hotelObject[@"imageUrl"] = dictionary[@"imageUrl"];
        hotelObject[@"starsUrl"] = dictionary[@"starsUrl"];
        hotelObject[@"price"] = dictionary[@"price"];
        hotelObject[@"currencyCode"] = dictionary[@"currencyCode"];
        hotelObject[@"amenities"] = dictionary[@"amenities"];
        hotelObject[@"description"] = dictionary[@"description"];
        hotelObject[@"finePrint"] = dictionary[@"finePrint"];
        [hotelObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                // The object has been saved.
                NSLog(@"Hotel has been saved");
            } else {
                // There was a problem, check error.description
            }
        }];
        
    }
}

// NOTE: no longer used.
// it will only be used for data population later.
- (void) initSearchResult {
    self.searchResults = @[
                           @{@"location": @"Portland, OR",
                             @"hotelAddress": @"400 SW Broadway, Portland, OR 97205",
                             @"lat": @45.5210634,
                             @"lng": @-122.6805098,
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
                             @"lat": @45.5201256,
                             @"lng": @-122.6794443,
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
                             @"lat": @45.5215199,
                             @"lng": @-122.6765451,
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
