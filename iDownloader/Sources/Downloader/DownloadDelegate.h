//
//  DownloadDelegate.h
//  iDownloader
//
//  Created by Roman on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Downloader;

@protocol DownloadDelegate <NSObject>
@optional
-(void) didStartDownload:(Downloader *) downloaderInst;
-(void) didDownloadFailed:(Downloader *) downloaderInst withError:(NSString *) error;
-(void) didDownloadCancel:(Downloader *) downloaderInst;
-(void) didFinishDownload:(Downloader *) downloaderInst;
-(void) didProgressDownload:(Downloader *) downloaderInst withPercents:(NSNumber *) percents;

@end
