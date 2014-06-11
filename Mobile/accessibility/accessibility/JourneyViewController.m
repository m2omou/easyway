//
//  JourneyViewController.m
//  accessibility
//
//  Created by Tchikovani on 09/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "JourneyViewController.h"
#import "TransportTypeCell.h"

@interface JourneyViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *journeyTableView;
@property (nonatomic, strong) NSMutableDictionary *journey;

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
    self.view.backgroundColor = [UIColor colorWithRed:125.0f/255.0f green:167.0f/255.0f blue:212.0f/255.0f alpha:1];
    self.title = @"Itinéraire";
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Cancel"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                  action:@selector(cancelJourney:)];
    self.navigationItem.rightBarButtonItem = cancelBtn;
    self.journeyTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 100, self.view.frame.size.width - 10, self.view.frame.size.height - 170)];
    self.journeyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

#pragma mark - UITableView delegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *type = [[[self.journey valueForKey:@"sections"] objectAtIndex:indexPath.section] valueForKey:@"type"];
    if ([type isEqualToString:@"public_transport"]) {
        return (115);
    }
    return 50;
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
