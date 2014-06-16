//
//  WalkingTypeCell.m
//  accessibility
//
//  Created by Tchikovani on 10/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "WalkingTypeCell.h"

@interface WalkingTypeCell ()

@property (nonatomic, strong) UIImageView *accessibilityImage;
@property (nonatomic, strong) UILabel *allerJusquaLabel;

@end

@implementation WalkingTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessibilityImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
        self.accessibilityImage.image = [UIImage imageNamed:@"walking.png"];
        [self addSubview:self.accessibilityImage];
        
        self.timeActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 50, 15)];
        self.timeActivityLabel.textAlignment = NSTextAlignmentCenter;
        self.timeActivityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
        [self addSubview:self.timeActivityLabel];
        
        self.allerJusquaLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 100, 15)];
        self.allerJusquaLabel.text = @"Aller jusqu'à :";
        self.allerJusquaLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(13.0)];
        [self addSubview:self.allerJusquaLabel];
        self.allerJusquaContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 200, 15)];
        self.allerJusquaContentLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
        self.allerJusquaContentLabel.numberOfLines = 0;
        [self addSubview:self.allerJusquaContentLabel];
        
        self.voirDetailMap = [UIButton buttonWithType:UIButtonTypeCustom];
        self.voirDetailMap.frame = CGRectMake(265, 15, 35, 35);
        [self.voirDetailMap setBackgroundImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
        [self addSubview:self.voirDetailMap];
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
