//
//  JourneyViewController.m
//  accessibility
//
//  Created by Tchikovani on 09/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "JourneyViewController.h"
#import "TransportTypeCell.h"
#import "WalkingTypeCell.h"
#import "TransferTypeCell.h"
#import "WalkingPathViewController.h"

@interface JourneyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *journeyTableView;
@property (nonatomic, strong) NSMutableDictionary *journey;
@property (nonatomic, strong) UILabel *nombreDeCorrespondanceContentLabel;
@property (nonatomic, strong) UILabel *durationContentLabel;

@end

@implementation JourneyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithJourney:(NSMutableDictionary *)journey
{
    self = [super initWithNibName:@"JourneyViewController" bundle:nil];
    if (self) {
        self.journey = [[NSMutableDictionary alloc] initWithDictionary:journey];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.journeyTableView.delegate = self;
    self.journeyTableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithRed:249.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1];
    self.title = @"Itinéraire";
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Annuler"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                  action:@selector(cancelJourney:)];
    self.navigationItem.rightBarButtonItem = cancelBtn;
    self.journeyTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 10, self.view.frame.size.height - 75)];
    self.journeyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.journeyTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(5, 10, self.view.frame.size.width - 10, 115)];
    self.journeyTableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
   
    UILabel *nombreDeCorrespondanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 230, 15)];
    nombreDeCorrespondanceLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:(15.0)];
    nombreDeCorrespondanceLabel.text = @"Nombre de correspondances";
    
    nombreDeCorrespondanceLabel.textColor = [UIColor colorWithRed:62.0f/255.0f green:164.0f/255.0f blue:243.0f/255.0f alpha:1];
    [self.journeyTableView.tableHeaderView addSubview:nombreDeCorrespondanceLabel];
    self.nombreDeCorrespondanceContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 15)];
    self.nombreDeCorrespondanceContentLabel.font = [UIFont fontWithName:@"Helvetica" size:(15.0)];
    self.nombreDeCorrespondanceContentLabel.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
    NSString *nbTransfer = [NSString stringWithFormat:@"%@", [self.journey valueForKey:@"nb_transfers"]];
    
    self.nombreDeCorrespondanceContentLabel.text = ([nbTransfer isEqualToString:@"0"] ? @"Aucune" : nbTransfer);
    [self.journeyTableView.tableHeaderView addSubview:self.nombreDeCorrespondanceContentLabel];
    
    UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 120, 15)];
    durationLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:(15.0)];
    durationLabel.text = @"Durée";
    durationLabel.textColor = [UIColor colorWithRed:62.0f/255.0f green:164.0f/255.0f blue:243.0f/255.0f alpha:1];
    [self.journeyTableView.tableHeaderView addSubview:durationLabel];
    self.durationContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 120, 15)];
    self.durationContentLabel.font = [UIFont fontWithName:@"Helvetica" size:(15.0)];
    self.durationContentLabel.textColor = [UIColor colorWithRed:50.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1];
    NSString *durationString = [self.journey valueForKey:@"duration"];
    int duration = [durationString intValue] / 60;
    int hour = duration / 60;
    int min = duration % 60;
    self.durationContentLabel.text = [NSString stringWithFormat:@"%dh%02d", hour, min];
    [self.journeyTableView.tableHeaderView addSubview:self.durationContentLabel];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 114, self.view.frame.size.width, 1)];
    separator.backgroundColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1];
    [self.journeyTableView.tableHeaderView addSubview:separator];
    self.journeyTableView.layer.borderWidth = 1.0f;
    self.journeyTableView.layer.borderColor = [UIColor colorWithRed:206.0f/255.0f green:206.0f/255.0f blue:206.0f/255.0f alpha:1].CGColor;
    [self.view addSubview:self.journeyTableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Selectors

- (IBAction)cancelJourney:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)showWalkingPathMap:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.journeyTableView];
    NSIndexPath *indexPath = [self.journeyTableView indexPathForRowAtPoint:buttonPosition];
    if (indexPath != nil)
    {
        WalkingPathViewController *walkPath = [[WalkingPathViewController alloc] init];
        walkPath.geoJson = [[self.journey valueForKey:@"sections"] objectAtIndex:indexPath.section][@"geojson"];
        [self.navigationController pushViewController:walkPath animated:YES];
    }
}

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = [[[self.journey valueForKey:@"sections"] objectAtIndex:indexPath.section] valueForKey:@"type"];
    if ([type isEqualToString:@"public_transport"]) {
        return (130);
    }
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *type = [[[self.journey valueForKey:@"sections"] objectAtIndex:section] valueForKey:@"type"];
    if ([type isEqualToString:@"street_network"]) {
        return 1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = [[[self.journey valueForKey:@"sections"] objectAtIndex:indexPath.section] valueForKey:@"type"];
    
    if ([type isEqualToString:@"public_transport"]) {
        static NSString *CellIdentifier = @"TransportTypeCell";
        
        TransportTypeCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TransportTypeCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
        }
        [cell fillCell:self.journey and:indexPath];
        return cell;
    }

    else if ([type isEqualToString:@"street_network"]) {
        static NSString *CellIdentifier = @"WalkingTypeCell";
        
        WalkingTypeCell *cell = [tableView
                                   dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WalkingTypeCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
            [cell.voirDetailMap addTarget:self action:@selector(showWalkingPathMap:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd'T'HHmmss"];
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *date = [dateFormat dateFromString:[[self.journey valueForKey:@"sections"] objectAtIndex:indexPath.section][@"departure_date_time"]];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
        [components setTimeZone:[NSTimeZone localTimeZone]];
        cell.timeActivityLabel.text = [NSString stringWithFormat:@"%02d h %02d", [components hour], [components minute]];
        cell.allerJusquaContentLabel.text = [[self.journey valueForKey:@"sections"] objectAtIndex:indexPath.section][@"to"][@"name"];
        CGSize size = [cell.allerJusquaContentLabel.text sizeWithFont:cell.allerJusquaContentLabel.font constrainedToSize:CGSizeMake(135, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = cell.allerJusquaContentLabel.frame;
        
        // Resize only if needs to grow, don't shrink
        if (frame.size.height < size.height) {
            frame.size.height = size.height;
        }
        
        cell.allerJusquaContentLabel.frame = frame;
        return cell;
    }
    
    else if ([type isEqualToString:@"transfer"]) {
        static NSString *CellIdentifier = @"TransferTypeCell";
        
        TransferTypeCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[TransferTypeCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
            [cell.voirDetailMap addTarget:self action:@selector(showWalkingPathMap:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyyMMdd'T'HHmmss"];
        [dateFormat setTimeZone:[NSTimeZone localTimeZone]];
        NSDate *date = [dateFormat dateFromString:[[self.journey valueForKey:@"sections"] objectAtIndex:indexPath.section][@"departure_date_time"]];
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:date];
        [components setTimeZone:[NSTimeZone localTimeZone]];
        cell.timeActivityLabel.text = [NSString stringWithFormat:@"%02d h %02d", [components hour], [components minute]];
        cell.allerJusquaContentLabel.text = [[self.journey valueForKey:@"sections"] objectAtIndex:indexPath.section][@"to"][@"name"];
        CGSize size = [cell.allerJusquaContentLabel.text sizeWithFont:cell.allerJusquaContentLabel.font constrainedToSize:CGSizeMake(135, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = cell.allerJusquaContentLabel.frame;
        
        // Resize only if needs to grow, don't shrink
        if (frame.size.height < size.height) {
            frame.size.height = size.height;
        }
        
        cell.allerJusquaContentLabel.frame = frame;
        return cell;
    }

    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"Autre";
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([[self.journey valueForKey:@"sections"] count]);
}

@end
