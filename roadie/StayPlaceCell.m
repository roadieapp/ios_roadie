//
//  StayPlaceCell.m
//  roadie
//
//  Created by Xin Suo on 11/23/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "StayPlaceCell.h"

@implementation StayPlaceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onAdd:(id)sender {
    [self.delegate stayPlaceCell:self click:0];
}

- (IBAction)onRemove:(id)sender {
    [self.delegate stayPlaceCell:self click:1];
}

- (IBAction)onTouchDown:(id)sender {
    [self.destinationDelegate stayPlaceCell:self];
}

@end
