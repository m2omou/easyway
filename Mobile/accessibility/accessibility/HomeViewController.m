//
//  HomeViewController.m
//  accessibility
//
//  Created by Tchikovani on 03/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "POICell.h"
#import "jaccedeCallApi.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, jaccedeCallApiDelegate>
{
    NSMutableArray *searchResults;
}

@property (nonatomic, strong) UILabel *searchPoiInstructions;
@property (nonatomic, strong) UITextField *inputWhat;
@property (nonatomic, strong) UITextField *inputWhere;
@property (nonatomic, strong) UITableView *typeAheadTableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) jaccedeCallApi *jaccedeApi;

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
    self.jaccedeApi = [[jaccedeCallApi alloc] init];
    self.jaccedeApi.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor colorWithRed:125.0f/255.0f green:167.0f/255.0f blue:212.0f/255.0f alpha:1];
    
    // Descriptif application
    self.searchPoiInstructions = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 + 10, self.view.frame.size.width, 20)];
    self.searchPoiInstructions.textAlignment = NSTextAlignmentCenter;
    self.searchPoiInstructions.text = @"Recherche de lieux accessibles et comment y accéder";
    self.searchPoiInstructions.font =  [UIFont fontWithName:@"HelveticaNeue" size:(12.0)];
    self.searchPoiInstructions.textColor = [UIColor whiteColor];
    [self.view addSubview:self.searchPoiInstructions];
    
    // Input what
    self.inputWhat = [[UITextField alloc] initWithFrame:CGRectMake(10, 45, self.view.frame.size.width - 20, 35)];
    self.inputWhat.placeholder = @" Quoi ? (Restaurant, hôtel, cinema ...)";
    self.inputWhat.borderStyle = UITextBorderStyleLine;
    self.inputWhat.backgroundColor = [UIColor whiteColor];
    self.inputWhat.delegate = self;
    self.inputWhat.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
    [self.inputWhat setReturnKeyType:UIReturnKeyDone];
    [self.inputWhat addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.inputWhat];
    
    // Input where
    self.inputWhere = [[UITextField alloc] initWithFrame:CGRectMake(10, 85, self.view.frame.size.width - 20, 35)];
    self.inputWhere.placeholder = @" Où ? (Paris, 92100, Normandie...)";
    self.inputWhere.borderStyle = UITextBorderStyleLine;
    self.inputWhere.backgroundColor = [UIColor whiteColor];
    self.inputWhere.delegate = self;
    self.inputWhere.font =  [UIFont fontWithName:@"HelveticaNeue" size:(13.0)];
    [self.inputWhere setReturnKeyType:UIReturnKeyDone];
    [self.inputWhere addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.inputWhere];
    
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

#pragma mark - UITextField

- (IBAction)textFieldDidChange:(id)sender
{
    [self.jaccedeApi searchPlaces:(self.inputWhat.text.length > 0 ? self.inputWhat.text : nil ) where:(self.inputWhere.text.length > 0 ? self.inputWhere.text : nil )];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResults count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (100);
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
    cell.nameLabel.text = [poi valueForKey:@"name"];
    NSString *urlIconType = [[poi valueForKeyPath:@"category"] valueForKeyPath:@"list_icon"];
    cell.iconType.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlIconType]]];
    cell.typeLabel.text = [poi valueForKey:@"main_keywork"];
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
        if ([self.inputWhat isFirstResponder]) {
            self.inputWhat.frame = CGRectMake(5, 5, self.view.frame.size.width - 70, 35);
        }
        else if ([self.inputWhere isFirstResponder]) {
            self.inputWhere.frame = CGRectMake(5, 5, self.view.frame.size.width - 70, 35);
        }
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
        if ([self.inputWhat isFirstResponder]) {
            self.inputWhat.frame = CGRectMake(10, 45, self.view.frame.size.width - 20, 35);
        }
        else if ([self.inputWhere isFirstResponder]) {
            self.inputWhere.frame = CGRectMake(10, 85, self.view.frame.size.width - 20, 35);
        }
    } completion:^(BOOL finished) {
        if (finished) {
            self.searchPoiInstructions.hidden = NO;
        }
    }];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    [searchResults removeAllObjects];
    if ([self.inputWhat isFirstResponder]) {
        self.inputWhat.text = @"";
        [self.inputWhat resignFirstResponder];
    }
    else if ([self.inputWhere isFirstResponder]) {
        self.inputWhere.text = @"";
        [self.inputWhere resignFirstResponder];
    }
    [self.typeAheadTableView reloadData];
}

#pragma mark - JaccedeApi

- (void)resultSearch:(NSMutableArray *)results
{
    [searchResults removeAllObjects];
    if ([results count] > 0) {
        NSLog(@"RESULTS = %@", results);
        [searchResults addObjectsFromArray:results];
    }
    [self.typeAheadTableView reloadData];
}

@end
