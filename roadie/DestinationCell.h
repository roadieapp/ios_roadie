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

- (void)destinationCellDelegate;

@end

@interface DestinationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *destinationField;

@property (nonatomic, weak) id<DestinationCellDelegate> delegate;

@end
