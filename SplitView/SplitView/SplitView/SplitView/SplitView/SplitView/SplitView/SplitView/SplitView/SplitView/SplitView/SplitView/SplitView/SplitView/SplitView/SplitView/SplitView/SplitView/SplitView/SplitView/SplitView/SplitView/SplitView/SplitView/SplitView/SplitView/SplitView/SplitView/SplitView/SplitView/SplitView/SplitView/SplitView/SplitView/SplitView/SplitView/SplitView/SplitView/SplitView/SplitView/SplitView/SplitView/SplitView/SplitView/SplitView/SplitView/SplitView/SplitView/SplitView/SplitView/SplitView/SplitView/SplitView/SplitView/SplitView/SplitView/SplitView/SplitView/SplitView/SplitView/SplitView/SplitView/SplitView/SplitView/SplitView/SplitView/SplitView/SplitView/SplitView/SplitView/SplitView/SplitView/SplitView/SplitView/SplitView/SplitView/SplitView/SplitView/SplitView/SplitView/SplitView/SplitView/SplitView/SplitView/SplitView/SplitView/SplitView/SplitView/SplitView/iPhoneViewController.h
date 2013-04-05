//
//  iPhoneViewController.h
//  SplitView
//
//  Created by Shaohuan Li on 16/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "baseapi.h"
#import "MasterViewController.h"
#import "Tesseract.h"


@interface iPhoneViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
}

@property (nonatomic) tesseract::TessBaseAPI *tess;
@property (strong, nonatomic) IBOutlet UIScrollView *bookView;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic) UIImage *selectedImg;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *annotationButton;
@property (nonatomic, strong) MBProgressHUD *progressHud;
@end
