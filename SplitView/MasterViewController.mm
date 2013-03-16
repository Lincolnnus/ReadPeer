//
//  MasterViewController.m
//  SpitViewControllerDemo
//
//  Created by Shaohuan Li on 14/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "MasterViewController.h"
#import "AnnotationModel.h"

@implementation MasterViewController
{
    NSMutableArray *annotations;
}

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
    
    AnnotationModel *one = [[AnnotationModel alloc] init];
    one.content = @"The collision between wolf breath and a straw block results in the destruction of the straw block";
    one.annot = @"This is interesting";
    
    [annotations addObject:one];
     AnnotationModel *two = [[AnnotationModel alloc] init];
    two.content = @"Integrate the physics engine in the game project";
    two.annot = @"How to implement the circle-rectangle interaction?";
    
    [annotations addObject:two];

    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*[self.delegate didSelectCustomer:selectedCustomer];*/
    /*[self.navController pushViewController:animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];*/
    [self performSegueWithIdentifier:@"segueToAnnotationDetails" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToAnnotationDetails"])
    {
         NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
         AnnotationModel *selectedAnnotation = [annotations objectAtIndex:[selectedRowIndex row]];
       AnnotDetailViewController *annotController=[segue destinationViewController];
        annotController.currentAnnot=selectedAnnotation;
       /* NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        NSInteger rowNumber = selectedIndexPath.row;
        
        AnnotationViewController *detailsTVC = [[segue destinationViewController] visibleViewController];*/
        
       /* mySQLiteDB = (SQLiteDB *) [locationsArray objectAtIndex:rowNumber];
        
        DetailsTVC *detailsTVC = [segue destinationViewController];
        
        detailsTVC.detailsObject = mySQLiteDB;*/
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate



@end
