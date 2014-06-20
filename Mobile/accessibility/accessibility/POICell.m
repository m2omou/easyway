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
        self.iconType = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 45, 45)];
        [self addSubview:self.iconType];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 3, 200, 15)];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:(14.0)];
        [self addSubview:self.nameLabel];
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 22, 200, 10)];
        self.typeLabel.textColor = [UIColor blackColor];
        self.typeLabel.font =  [UIFont fontWithName:@"Helvetica-Light" size:(12.0)];
        [self addSubview:self.typeLabel];
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 35, 250, 25)];
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.font =  [UIFont fontWithName:@"Helvetica" size:(13.0)];
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
