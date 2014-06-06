//
//  HomeViewController.m
//  accessibility
//
//  Created by Tchikovani on 03/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "BuildJourneyViewController.h"
#import "POICell.h"
#import "AFNetworking.h"
#import "JaccedeCallApi.h"

#define kGOOGLE_API_KEY @"AIzaSyChDT7OcuZVbbBTrpixoG6rP_0ws4HuZH4"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *searchResults;
}

@property (nonatomic, strong) UILabel *searchPoiInstructions;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UITableView *typeAheadTableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSOperationQueue *imageDownloadingQueue;
@property (nonatomic, strong) NSCache *imageCache;

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Home";
    self.typeAheadTableView.delegate = self;
    self.typeAheadTableView.dataSource = self;
    self.imageDownloadingQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadingQueue.maxConcurrentOperationCount = 4; // many servers limit how many concurrent requests they'll accept from a device, so make sure to set this accordingly
    
    self.imageCache = [[NSCache alloc] init];

    // Do any additional setup after loading the view.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor colorWithRed:125.0f/255.0f green:167.0f/255.0f blue:212.0f/255.0f alpha:1];
    
    // Descriptif application
    self.searchPoiInstructions = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 10, self.view.frame.size.width, 20)];
    self.searchPoiInstructions.textAlignment = NSTextAlignmentCenter;
    self.searchPoiInstructions.text = @"Recherche de lieux et voir l'accessibilité";
    self.searchPoiInstructions.font =  [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    self.searchPoiInstructions.textColor = [UIColor whiteColor];
    [self.view addSubview:self.searchPoiInstructions];
    
    // Input Search
    self.searchBar = [[UITextField alloc] initWithFrame:CGRectMake(10, 45, self.view.frame.size.width - 20, 35)];
    self.searchBar.placeholder = @"Où aimeriez vous aller ?";
    self.searchBar.borderStyle = UITextBorderStyleLine;
    self.searchBar.backgroundColor = [UIColor whiteColor];
    self.searchBar.delegate = self;
    self.searchBar.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
    [self.searchBar setReturnKeyType:UIReturnKeyDone];
    [self.searchBar addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.searchBar];
    
    // Table View and search result initialisation
    self.typeAheadTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 45, self.view.frame.size.width - 10, 150)];
    self.typeAheadTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.typeAheadTableView.hidden = YES;
    [self.view addSubview:self.typeAheadTableView];
    searchResults = [[NSMutableArray alloc] init];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.cancelButton.frame = CGRectMake(self.view.frame.size.width - 70 + 10, 5, 60, 35);
    [self.cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) queryPlaces: (NSString *) place {
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&types=geocode&language=fr&sensor=true&key=%@", place, kGOOGLE_API_KEY];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        NSArray *predictions = [responseObject valueForKeyPath:@"predictions"];
        if ([predictions count] > 0) {
            searchResults = [NSMutableArray arrayWithArray:predictions];
            [self.typeAheadTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark - UITextField

- (IBAction)textFieldDidChange:(id)sender
{
    [self queryPlaces:self.searchBar.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildJourneyViewController *journeyView = [[BuildJourneyViewController alloc] init];
    journeyView.googleDestination = [[NSMutableDictionary alloc] initWithDictionary:[searchResults objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:journeyView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"POICell";
    
    POICell *cell = [tableView
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[POICell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell.
    NSDictionary *poi = [searchResults objectAtIndex:indexPath.row];
    cell.addressLabel.text = [poi valueForKey:@"description"];
    CGSize size = [cell.addressLabel.text sizeWithFont:cell.addressLabel.font constrainedToSize:CGSizeMake(cell.addressLabel.bounds.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    CGRect frame = cell.addressLabel.frame;
    
    // Resize only if needs to grow, don't shrink
    if (frame.size.height < size.height) {
        frame.size.height = size.height;
    }
    
    cell.addressLabel.frame = frame;
    return cell;
}

#pragma mark - Keyboard notification
/**
 *  Keyboard will show
 */
- (void)keyboardWillShow:(NSNotification*)notification {
    self.searchPoiInstructions.hidden = YES;
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.searchBar.frame = CGRectMake(5, 5, self.view.frame.size.width - 70, 35);
    } completion:^(BOOL finished) {
        [self.view addSubview:self.cancelButton];
        self.typeAheadTableView.hidden = NO;
    }];
}

/**
 *  Keyboard will hide
 */
- (void)keyboardWillHide:(NSNotification*)notification {
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self.cancelButton removeFromSuperview];
    self.typeAheadTableView.hidden = YES;
    [UIView animateWithDuration:duration animations:^{
        self.searchBar.frame = CGRectMake(10, 45, self.view.frame.size.width - 20, 35);
    } completion:^(BOOL finished) {
        if (finished) {
            self.searchPoiInstructions.hidden = NO;
        }
    }];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    [searchResults removeAllObjects];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.typeAheadTableView reloadData];
}

@end
