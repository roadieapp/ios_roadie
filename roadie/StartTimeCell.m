//
//  StartTimeCell.m
//  roadie
//
//  Created by Xin Suo on 11/23/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import "StartTimeCell.h"

@implementation StartTimeCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onClick:(id)sender {
    [self.delegate startTimeCell:self];
}

@end
