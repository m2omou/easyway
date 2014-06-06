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
        self.iconType = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
        [self addSubview:self.iconType];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 200, 20)];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(14.0)];
        [self addSubview:self.nameLabel];
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 200, 10)];
        self.typeLabel.textColor = [UIColor blackColor];
        self.typeLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Light" size:(11.0)];
        [self addSubview:self.typeLabel];
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
