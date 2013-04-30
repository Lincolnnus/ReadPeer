//
//  MasterViewController.m
//  SpitViewControllerDemo
//
//  Created by Shaohuan Li on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MasterViewController.h"
#import "AnnotationModel.h"
#import "AFJSONRequestOperation.h"
#define CommentApiURL @"http://readpeer.com/api/comments/"

@implementation MasterViewController

@synthesize annotController;
@synthesize annotations;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    annotations = [[NSMutableArray alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(void)updateAnnotations:(NSMutableArray *)annots
{
    annotations = annots;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"segueToAnnotationDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToAnnotationDetails"])
    {
         NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
         AnnotationModel *selectedAnnotation = [annotations objectAtIndex:[selectedRowIndex row]];
        annotController=[segue destinationViewController];
        annotController.currentAnnot=selectedAnnotation;
        
        NSURL *url = [NSURL URLWithString:[CommentApiURL stringByAppendingString:selectedAnnotation.aid]];
                      NSURLRequest *request = [NSURLRequest requestWithURL:url];
                      
                      AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSMutableArray *comments = [[NSMutableArray alloc] init];
            for (int i = 0; i < [JSON count];i++)
            {
                Comment *cms = [[Comment alloc] initWithJSON:JSON[i]];
                [comments addObject:cms];
            }
            [annotController updateComments:comments];
        } failure:nil];
                      
                      [operation start];
        
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [annotations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AnnotationCell";
    
    AnnotationModel *annotation = [annotations objectAtIndex:[indexPath row]];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
    }
    
    [[cell textLabel] setText:annotation.annot];
    cell.detailTextLabel.text= annotation.content;
    return cell;
}
#pragma mark - Table view delegate



@end
