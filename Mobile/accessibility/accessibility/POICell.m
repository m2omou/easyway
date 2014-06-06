//
//  POICell.m
//  accessibility
//
//  Created by Tchikovani on 05/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "POICell.h"

@implementation POICell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 295, 30)];
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
        self.addressLabel.numberOfLines = 0;
        [self addSubview:self.addressLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
