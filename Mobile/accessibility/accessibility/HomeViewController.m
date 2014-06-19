//
//  HomeViewController.m
//  accessibility
//
//  Created by Tchikovani on 03/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "HomeViewController.h"
#import "BuildJourneyViewController.h"
#import "GooglePlacesAPI.h"
#import "JaccedeCallApi.h"
#import "POICell.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, JaccedeCallApiDelegate, GooglePlacesAPIDelegate>
{
    NSMutableArray *searchResults;
    GooglePlacesAPI *googlePlacesAPICaller;
}

@property (nonatomic, strong) UILabel *searchPoiInstructions;
@property (nonatomic, strong) UITextField *searchBar;
@property (nonatomic, strong) UITableView *typeAheadTableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSOperationQueue *imageDownloadingQueue;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, strong) UIButton *jaccedePOISearch;
@property (nonatomic, strong) JaccedeCallApi *jaccedeApi;
@property (nonatomic, strong) UIButton *addressSearch;

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
    googlePlacesAPICaller = [[GooglePlacesAPI alloc] init];
    googlePlacesAPICaller.delegate = self;
    self.jaccedeApi = [[JaccedeCallApi alloc] init];
    self.jaccedeApi.delegate = self;
    self.imageDownloadingQueue = [[NSOperationQueue alloc] init];
    self.imageDownloadingQueue.maxConcurrentOperationCount = 4;
    
    self.imageCache = [[NSCache alloc] init];
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
    
    self.jaccedePOISearch = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jaccedePOISearch.frame = CGRectMake(10, 90, 250, 15);
    self.jaccedePOISearch.tag = 1;
    [self.jaccedePOISearch setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
    [self.jaccedePOISearch setTitle:@" Points d'intérêts jaccede" forState:UIControlStateNormal];
    [self.jaccedePOISearch addTarget:self action:@selector(jaccedePOISearchButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.jaccedePOISearch.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:self.jaccedePOISearch];
    
    self.addressSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addressSearch.frame = CGRectMake(10, 110, 250, 15);
    self.addressSearch.tag = 0;
    [self.addressSearch setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    [self.addressSearch setTitle:@" Adresses" forState:UIControlStateNormal];
    [self.addressSearch addTarget:self action:@selector(addressSarchButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
    self.addressSearch.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.view addSubview:self.addressSearch];
    
    // Table View and search result initialisation
    self.typeAheadTableView = [[UITableView alloc] initWithFrame:CGRectMake(5, 45, self.view.frame.size.width - 10, 150)];
    self.typeAheadTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.typeAheadTableView.hidden = YES;
    [self.view addSubview:self.typeAheadTableView];
    searchResults = [[NSMutableArray alloc] init];
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.cancelButton setTitle:@"Annuler" forState:UIControlStateNormal];
    self.cancelButton.frame = CGRectMake(self.view.frame.size.width - 70 + 10, 5, 60, 35);
    [self.cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    if ([self.view.subviews containsObject:self.cancelButton]) {
        [self.searchBar becomeFirstResponder];
    }
}

- (IBAction)jaccedePOISearchButtonSelected:(id)sender
{
    if (self.jaccedePOISearch.tag == 1)
        return;
    else {
        self.jaccedePOISearch.tag = 1;
        [self.jaccedePOISearch setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        self.addressSearch.tag = 0;
        [self.addressSearch setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }
}

- (IBAction)addressSarchButtonSelected:(id)sender
{
    if (self.addressSearch.tag == 1)
        return;
    else {
        self.addressSearch.tag = 1;
        [self.addressSearch setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateNormal];
        self.jaccedePOISearch.tag = 0;
        [self.jaccedePOISearch setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextField

- (IBAction)textFieldDidChange:(id)sender
{
    [searchResults removeAllObjects];
    [self.typeAheadTableView reloadData];
    if (self.jaccedePOISearch.tag == 1) {
        [self.jaccedeApi searchPlaces:self.searchBar.text where:nil];
    }
    else {
        [googlePlacesAPICaller searchGooglePlaces:self.searchBar.text];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildJourneyViewController *journeyView = [[BuildJourneyViewController alloc] init];
    NSMutableDictionary *poi = [[NSMutableDictionary alloc] initWithDictionary:[searchResults objectAtIndex:indexPath.row]];
    if (self.jaccedePOISearch.tag == 1) {
        [poi setObject:[poi objectForKey:@"name"] forKey:@"description"];
    }
    journeyView.destination = [[NSMutableDictionary alloc] initWithDictionary:poi];
    [self.navigationController pushViewController:journeyView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.jaccedePOISearch.tag == 1) {
        return (70);
    }
    return (50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.jaccedePOISearch.tag == 1) {
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
        cell.nameLabel.text = [poi valueForKey:@"name"];
        NSString *urlIconType = [[poi valueForKeyPath:@"category"] valueForKeyPath:@"list_icon"];
        UIImage *cachedImage = [self.imageCache objectForKey:urlIconType];
        if (cachedImage) {
            cell.iconType.image = cachedImage;
        }
        else {
            cell.iconType.image = [UIImage imageNamed:@"loading"];
            
            [self.imageDownloadingQueue addOperationWithBlock:^{
                
                NSURL *imageUrl   = [NSURL URLWithString:urlIconType];
                NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
                UIImage *image    = nil;
                if (imageData)
                    image = [UIImage imageWithData:imageData];
                if (image)
                {
                    
                    [self.imageCache setObject:image forKey:urlIconType];
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        POICell *updateCell = (POICell *)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            updateCell.iconType.image = image;
                    }];
                }
            }];
        }
        cell.typeLabel.text = [poi valueForKey:@"main_keyword"];
        cell.addressLabel.text = [poi valueForKey:@"address"];
        CGSize size = [cell.addressLabel.text sizeWithFont:cell.addressLabel.font constrainedToSize:CGSizeMake(cell.addressLabel.bounds.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = cell.addressLabel.frame;
        
        // Resize only if needs to grow, don't shrink
        if (frame.size.height < size.height) {
            frame.size.height = size.height;
        }
        
        cell.addressLabel.frame = frame;
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"GoogleCell";
        
        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:CellIdentifier];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.textLabel.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
            cell.textLabel.numberOfLines = 0;
        }
        
        // Configure the cell.
        NSDictionary *poi = [searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = [poi valueForKey:@"description"];
        CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(cell.textLabel.bounds.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        CGRect frame = cell.textLabel.frame;
        
        // Resize only if needs to grow, don't shrink
        if (frame.size.height < size.height) {
            frame.size.height = size.height;
        }
        
        cell.textLabel.frame = frame;
        return cell;
    }
    return nil;
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

#pragma mark - Google API delegate methods

- (void)resultSearchForPOIPlaces:(NSMutableArray *)results
{
    [searchResults removeAllObjects];
    if ([results count] > 0) {
        [searchResults addObjectsFromArray:results];
    }
    [self.typeAheadTableView reloadData];
}

#pragma mark - JaccedeApi

- (void)resultSearch:(NSMutableArray *)results
{
    [searchResults removeAllObjects];
    if ([results count] > 0) {
        [searchResults addObjectsFromArray:results];
    }
    [self.typeAheadTableView reloadData];
}

@end
