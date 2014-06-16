//
//  WalkingPathViewController.m
//  accessibility
//
//  Created by Tchikovani on 13/06/2014.
//  Copyright (c) 2014 Tchikovani. All rights reserved.
//

#import "WalkingPathViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface WalkingPathViewController ()

@end

@implementation WalkingPathViewController

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
    self.title = @"Path";
   
    NSMutableArray *startCoordinates = [self.geoJson objectForKey:@"coordinates"][0];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[[startCoordinates objectAtIndex:1] doubleValue]
                                                            longitude: [[startCoordinates objectAtIndex:0]  doubleValue]
                                                                 zoom:16];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    GMSMutablePath *path = [GMSMutablePath path];
    
    NSMutableArray *coordinates = [self.geoJson objectForKey:@"coordinates"];
    
    GMSMarker *start = [[GMSMarker alloc] init];
    start.position = CLLocationCoordinate2DMake([[startCoordinates objectAtIndex:1] doubleValue], [[startCoordinates objectAtIndex:0]  doubleValue]);
    start.icon = [UIImage imageNamed:@"start"];
    start.map = mapView;
    for (NSMutableArray *coordinate in coordinates)
    {
        [path addLatitude:[[coordinate objectAtIndex:1] doubleValue] longitude:[[coordinate objectAtIndex:0] doubleValue]];
    }
    
    NSMutableArray *endCoordinates = [[self.geoJson objectForKey:@"coordinates"] lastObject];
    
    GMSMarker *end = [[GMSMarker alloc] init];
    end.position = CLLocationCoordinate2DMake([[endCoordinates objectAtIndex:1] doubleValue],[[endCoordinates objectAtIndex:0] doubleValue]);
    end.icon = [UIImage imageNamed:@"end"];
    end.map = mapView;

    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = mapView;
    self.view = mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
