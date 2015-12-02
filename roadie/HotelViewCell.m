//
//  HotelViewCell.m
//  roadie
//
//  Created by David Wang on 11/22/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "HotelViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface HotelViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *hotelImageView;

@property (weak, nonatomic) IBOutlet UILabel *hotelNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *hotelStarsImageView;

@property (weak, nonatomic) IBOutlet UILabel *hotelAddressLabel;

@end

@implementation HotelViewCell

- (void) setHotel: (Hotel *)hotel {
    _hotel = hotel;
    
    self.hotelNameLabel.text = self.hotel.hotelName;
    [self.hotelNameLabel sizeToFit];
    
    self.hotelAddressLabel.text = self.hotel.hotelAddress;
    [self.hotelAddressLabel sizeToFit];
    
    // rounded corners and border for hotel image
    CALayer *layer = [self.hotelImageView layer];
    [layer setCornerRadius:6.0];
    [layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [layer setBorderWidth:3.0];
    [layer setMasksToBounds:YES];
    [self.hotelImageView setImageWithURL:self.hotel.imageUrl];
    NSString *starImageName = [NSString stringWithFormat:@"%@_%@", self.hotel.starRating, @"stars"];
    self.hotelStarsImageView.image = [UIImage imageNamed: starImageName];
    
    self.priceLabel.text = [NSString stringWithFormat:@"$%ld", (long)self.hotel.price];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
