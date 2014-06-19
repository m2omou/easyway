//
//  TransportTypeCell.m
//  accessibility
//
//  Created by Tchikovani on 10/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "TransportTypeCell.h"
#import "UIColor+ColorWithHexAndAlpha.h"

@interface TransportTypeCell ()

@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *directionLabel;
@property (nonatomic, strong) UILabel *descenteLabel;
@property (nonatomic, strong) UIImageView *type;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *timeActivityLabel;
@property (nonatomic, strong) UILabel *fromLabelContent;
@property (nonatomic, strong) UILabel *directionLabelContent;
@property (nonatomic, strong) UILabel *descenteLabelContent;

@end

@implementation TransportTypeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.type = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, 25, 25)];
        [self addSubview:self.type];
        
        self.line = [[UILabel alloc] initWithFrame:CGRectMake(35, 40, 25, 25)];
        self.line.textColor = [UIColor whiteColor];
        self.line.textAlignment = NSTextAlignmentCenter;
        self.line.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(13.0)];
        [self addSubview:self.line];
        
        self.timeActivityLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 70, 50, 15)];
        self.timeActivityLabel.textAlignment = NSTextAlignmentCenter;
        self.timeActivityLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
        [self addSubview:self.timeActivityLabel];
        
        self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 90, 15)];
        self.fromLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(13.0)];
        self.fromLabel.text = @"A partir de :";
        [self addSubview:self.fromLabel];
        
        self.fromLabelContent = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, 230, 15)];
        self.fromLabelContent.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
        self.fromLabelContent.text = @"A partir de :";
        [self addSubview:self.fromLabelContent];
        
        self.directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 70, 15)];
        self.directionLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(13.0)];
        self.directionLabel.text = @"Direction :";
        [self addSubview:self.directionLabel];
        
        self.directionLabelContent = [[UILabel alloc] initWithFrame:CGRectMake(70, 55, 230, 15)];
        self.directionLabelContent.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
        [self addSubview:self.directionLabelContent];
        
        self.descenteLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 75, 90, 15)];
        self.descenteLabel.font =  [UIFont fontWithName:@"HelveticaNeue-Bold" size:(13.0)];
        self.descenteLabel.text = @"Descendre à :";
        [self addSubview:self.descenteLabel];
        
        self.descenteLabelContent = [[UILabel alloc] initWithFrame:CGRectMake(70, 90, 230, 15)];
        self.descenteLabelContent.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
        [self addSubview:self.descenteLabelContent];
    }
    return self;
}

- (void)fillCell:(NSMutableDictionary *)journey and:(NSIndexPath *)indexPath
{
    NSString *infos = [[[journey valueForKey:@"sections"] objectAtIndex:indexPath.section] valueForKey:@"display_informations"];
    
    if ([[infos valueForKey:@"physical_mode"] isEqualToString:@"Bus"]) {
        self.type.image = [UIImage imageNamed:@"bus"];
    }
    else {
        self.type.image = nil;
    }
    self.line.text = [infos valueForKey:@"label"];
    self.line.backgroundColor = [UIColor colorWithHex:[infos valueForKey:@"color"] andAlpha:1];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd'T'HHmmss"];
    [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
    NSArray *stopPoints = [[[journey valueForKey:@"sections"] objectAtIndex:indexPath.section] valueForKey:@"stop_date_times"];
    NSDate *date = [dateFormat dateFromString:[stopPoints objectAtIndex:0][@"departure_date_time"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
    [components setTimeZone:[NSTimeZone localTimeZone]];
    self.timeActivityLabel.text = [NSString stringWithFormat:@"%02d h %02d", [components hour], [components minute]];
    self.fromLabelContent.text = [stopPoints objectAtIndex:0][@"stop_point"][@"name"];
    self.directionLabelContent.text = [infos valueForKey:@"direction"];
    self.descenteLabelContent.text = [stopPoints lastObject][@"stop_point"][@"name"];
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
