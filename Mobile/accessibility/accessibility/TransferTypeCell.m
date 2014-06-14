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
        self.transferImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 25, 25)];
        self.transferImage.image = [UIImage imageNamed:@"connection.png"];
        [self addSubview:self.transferImage];
        
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
        [self addSubview:self.allerJusquaContentLabel];
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
