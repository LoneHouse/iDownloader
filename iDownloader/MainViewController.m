//
//  MainViewController.m
//  iDownloader
//
//  Created by Roman on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

DownloadPool *downloadPool;

@implementation MainViewController
@synthesize imgView;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)buttonPress:(id)sender{

    if([((UIButton*)sender).titleLabel.text isEqualToString:@"download"]){
        downloadPool=[[DownloadPool alloc]init];
        [downloadPool addNewDownloadFromURL:@"http://wowjp.net/_ph/2/299418629.jpg" withDelegate:self];
  [downloadPool addNewDownloadFromURL:@"http://media.steampowered.com/client/installer/steam.dmg" withDelegate:self];
        [downloadPool addNewDownloadFromURL:@"http://media.steampowered.com/client/installer/steam.dmg" withDelegate:self];
        [downloadPool addNewDownloadFromURL:@"http://megaobzor.com/load/stati/warcraft123patch1.jpg" withDelegate:self];
    }
    
    if([((UIButton*)sender).titleLabel.text isEqualToString:@"Add"])
    {
        //[downloadPool addNewDownloadFromURL:@"http://cdn.sstatic.net/stackoverflow/img/apple-touch-icon.png" withDelegate:self];

    }
    
    if([((UIButton*)sender).titleLabel.text isEqualToString:@"cancel"]) {
        //[downloadPool cancelDownloadByURL:@"http://media.steampowered.com/client/installer/steam.dmg"];
        [downloadPool cancelAllDownloads];
    }
}

-(void)didDownloadFailed:(Downloader *)downloaderInst withError:(NSString *)error{
	NSLog(@"%@",error);
}

-(void)didProgressDownload:(Downloader *)downloaderInst withPercents:(NSNumber *)percents{
    NSLog(@"Download %@ - %@",downloaderInst.downloadFileName, percents);
}

-(void)didFinishDownload:(Downloader *)downloaderInst{
    //get sandbox directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *sandBoxPath = [documentsDirectory stringByDeletingLastPathComponent];
    NSError *error;
    [downloaderInst.downloadedData writeToFile:[NSString stringWithFormat:@"%@/Documents/%@",sandBoxPath,downloaderInst.downloadFileName] options:NSDataWritingFileProtectionNone error:&error];
    self.imgView.image = [[UIImage alloc]initWithData:downloaderInst.downloadedData];
    
    NSLog(@"Loading finished. File saved to %@/Documents/%@",sandBoxPath,downloaderInst.downloadFileName);
}

-(void)didStartDownload:(Downloader *)downloaderInst{
    NSLog(@"Start download %@",downloaderInst.downloadURL);
}

-(void)didDownloadCancel:(Downloader *)downloaderInst{
    NSLog(@"Cancel");
}
@end
