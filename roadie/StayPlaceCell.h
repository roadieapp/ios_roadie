//
//  StayPlaceCell.h
//  roadie
//
//  Created by Xin Suo on 11/23/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StayPlaceCell;

@protocol StayPlaceCellDelegate <NSObject>

- (void)stayPlaceCell: (StayPlaceCell *)cell click:(int)buttonType;

@end

@protocol StayPlaceCellDestinationDelegate <NSObject>

- (void)stayPlaceCell: (StayPlaceCell *)cell;

@end

@interface StayPlaceCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UITextField *destinationTextField;

@property (nonatomic, weak) id<StayPlaceCellDelegate> delegate;
@property (nonatomic, weak) id<StayPlaceCellDestinationDelegate> destinationDelegate;

@end
