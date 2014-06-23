//
//  TransferTableViewCell.m
//  accessibility
//
//  Created by Tchikovani on 10/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "TransferTypeCell.h"

@interface TransferTypeCell ()

@property (nonatomic, strong) UIImageView *transferImage;
@property (nonatomic, strong) UILabel *allerJusquaLabel;

@end

@implementation TransferTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.transferImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
        self.transferImage.image = [UIImage imageNamed:@"connection"];
        [self addSubview:self.transferImage];
        
        self.timeActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 50, 15)];
        self.timeActivityLabel.textAlignment = NSTextAlignmentCenter;
        self.timeActivityLabel.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
        self.timeActivityLabel.font = [UIFont fontWithName:@"Helvetica" size:(13.0)];
        [self addSubview:self.timeActivityLabel];
        
        self.allerJusquaLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 105, 15)];
        self.allerJusquaLabel.text = @"Aller jusqu'à :";
        self.allerJusquaLabel.textColor = [UIColor colorWithRed:250.0f/255.0f green:130.0f/255.0f blue:77.0f/255.0f alpha:1];
        self.allerJusquaLabel.font =  [UIFont fontWithName:@"Helvetica-Bold" size:(15.0)];
        [self addSubview:self.allerJusquaLabel];
        self.allerJusquaContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 25, 200, 15)];
        self.allerJusquaContentLabel.font =  [UIFont fontWithName:@"Helvetica" size:(14.0)];
        self.allerJusquaContentLabel.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
        self.allerJusquaContentLabel.numberOfLines = 0;
        [self addSubview:self.allerJusquaContentLabel];
        
        self.voirDetailMap = [UIButton buttonWithType:UIButtonTypeCustom];
        self.voirDetailMap.frame = CGRectMake(265, 15, 35, 35);
        [self.voirDetailMap setBackgroundImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
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
