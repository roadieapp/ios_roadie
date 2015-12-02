//
//  StartTimeCell.h
//  roadie
//
//  Created by Xin Suo on 11/23/15.
//  Copyright © 2015 roadie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartTimeCell;

@protocol StartTimeCellDelegate <NSObject>

- (void)startTimeCell: (StartTimeCell *)cell;

@end

@interface StartTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (nonatomic, weak) id<StartTimeCellDelegate> delegate;

@end
