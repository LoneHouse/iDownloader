//
//  MainViewController.h
//  iDownloader
//
//  Created by Roman on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadPool.h"

@interface MainViewController : UIViewController<DownloadDelegate>

-(IBAction)buttonPress:(id)sender;

@property( nonatomic)IBOutlet UIImageView* imgView;

@end
