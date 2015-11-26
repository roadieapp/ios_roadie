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

- (void)stayPlaceCell: (StayPlaceCell *)cell;

@end

@interface StayPlaceCell : UITableViewCell

@property (nonatomic, weak) id<StayPlaceCellDelegate> delegate;

@end
