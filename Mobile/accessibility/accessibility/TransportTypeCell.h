//
//  TransportTypeCell.h
//  accessibility
//
//  Created by Tchikovani on 10/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportTypeCell : UITableViewCell

@property (nonatomic, strong) UIImageView *type;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *timeActivityLabel;
@property (nonatomic, strong) UILabel *fromLabelContent;
@property (nonatomic, strong) UILabel *directionLabelContent;
@property (nonatomic, strong) UILabel *descenteLabelContent;


- (void)fillCell:(NSMutableDictionary *)journey and:(NSIndexPath *)indexPath;

@end
