//
//  DestinationCell.h
//  roadie
//
//  Created by Xin Suo on 11/23/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DestinationCell;

@protocol DestinationCellDelegate <NSObject>

- (void)destinationCellDelegate: (DestinationCell *)cell;

@end

@interface DestinationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *destinationImage;
@property (weak, nonatomic) IBOutlet UITextField *destinationField;

@property (nonatomic, weak) id<DestinationCellDelegate> delegate;

@end
