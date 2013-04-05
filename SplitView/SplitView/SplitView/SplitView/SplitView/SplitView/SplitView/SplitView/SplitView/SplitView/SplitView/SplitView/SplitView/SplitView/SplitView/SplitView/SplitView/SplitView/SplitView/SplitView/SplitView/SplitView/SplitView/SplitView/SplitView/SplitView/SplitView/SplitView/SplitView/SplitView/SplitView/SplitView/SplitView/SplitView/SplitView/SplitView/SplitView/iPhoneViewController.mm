//
//  iPhoneViewController.m
//  SplitView
//
//  Created by Shaohuan Li on 16/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "iPhoneViewController.h"
#import "iPhoneTableListViewController.h"
#import "AFJSONRequestOperation.h"
@interface iPhoneViewController ()

@end

@implementation
iPhoneViewController{
    iPhoneTableListViewController *annotationView;
    NSString *result;
}

@synthesize popoverController;
@synthesize bookView;
@synthesize selectedImg;
@synthesize annotationButton;

- (IBAction)getAnnotations:(id)sender {
    [self.view addSubview: annotationView.view];
    
    //EFFECT: search annotations on the cloud after getting the text from OCR
    NSURL *url = [NSURL URLWithString:@"http://dbgpu.d1.comp.nus.edu.sg/xiaoli/ebook/api/search/of"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
    } failure:nil];
    
    [operation start];
   /* NSURL *aUrl = [NSURL URLWithString:@"http://dbgpu.d1.comp.nus.edu.sg/xiaoli/ebook/api/search/"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request
                                                                 delegate:self];
    
    [request setHTTPMethod:@"GET"];
    NSString *postString = [@"" stringByAppendingString:@"of"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (connection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        NSLog(@"success");
        
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Tesseract Sample"
                                    message:@"Fail to Connect to the Server"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        // Inform the user that the connection failed.
    }*/
}

-(void) hideAnnotation{
    [self.view removeFromSuperview];
}

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
    annotationView = [[iPhoneTableListViewController alloc] init];
	// Do any additional setup after loading the view.
}
- (IBAction)takePhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
	[self presentModalViewController:picker animated:YES];

}
- (IBAction)loadPhoto:(id)sender {
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
	[self presentModalViewController:picker animated:YES];

}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    for(UIView *subview in [bookView subviews]) {
        [subview removeFromSuperview];
    }
    selectedImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageView *pageView = [[UIImageView alloc] initWithImage:selectedImg];
    pageView.frame = CGRectMake(0, 0, bookView.frame.size.width, bookView.frame.size.height);
    [bookView addSubview: pageView];
    [popoverController dismissPopoverAnimated:YES];
    [picker dismissModalViewControllerAnimated:YES];
   // [self getTextfromImage:image];
    [self getAnnotations];
}
- (void)processOcrAt:(UIImage *)image
{
    
    Tesseract* tesseract = [[Tesseract alloc] initWithDataPath:@"tessdata" language:@"eng"];
    [tesseract setImage:image];
    [tesseract recognize];
    
    [self performSelectorOnMainThread:@selector(ocrProcessingFinished:)
                           withObject:[tesseract recognizedText]
                        waitUntilDone:NO];
}

- (void)ocrProcessingFinished:(NSString *)r
{
    result = r;
    [[[UIAlertView alloc] initWithTitle:@"Recognized Texts"
                                message:[NSString stringWithFormat:@"Recognized:\n%@", result]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"here");
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    
     NSError *error = nil;
    /* NSString* decoded = [NSString stringWithUTF8String:(const char *)[data bytes]];
     //NSString* decoded = [[NSString alloc] initWithData:data   encoding:NSUTF8StringEncoding];
     decoded=[decoded stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
     id response =[NSJSONSerialization JSONObjectWithData:[decoded dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];*/
    NSMutableArray* annotations =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    NSLog(@"error%@",error);
   /*  for ( int i= 0; i < [annotations count]; i++){
     [self addAnnotation:annotations[i]];
     }
    NSMutableArray *annotations = [[NSMutableArray alloc] init];*/
    
    /*AnnotationModel *one = [[AnnotationModel alloc] init];
    one.content = @"The collision between wolf breath and a straw block results in the destruction of the straw block";
    one.annot = @"This is interesting";
    one.aid =@"1";
    
    [annotations addObject:one];
    AnnotationModel *two = [[AnnotationModel alloc] init];
    two.content = @"Integrate the physics engine in the game project";
    two.annot = @"How to implement the circle-rectangle interaction?";
    two.aid =@"2";
    [annotations addObject:two];*/
    
    
    [annotationView updateAnnotations:annotations];//update the annotations
    NSLog(@"success update annotations");
}
- (void)getAnnotations
{
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHud.labelText = @"Processing OCR";
    
    [self.view addSubview:self.progressHud];
    [self.progressHud showWhileExecuting:@selector(processOcrAt:) onTarget:self withObject:selectedImg animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBookView:nil];
    [self setBookView:nil];
    [self setAnnotationButton:nil];
    [super viewDidUnload];
}
@end
