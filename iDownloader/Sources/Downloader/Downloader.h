//
//  Downloader.h
//  iDownloader
//
//  Created by Roman on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadDelegate.h"
#import "Reachability.h"

@interface Downloader : NSObject <NSURLConnectionDelegate>
@property (retain, nonatomic) NSString* downloadURL;
@property (retain, nonatomic) id<DownloadDelegate> delegate;
@property (retain, nonatomic) NSURLConnection* urlConnection;
@property (retain, nonatomic) NSMutableData* downloadedData;
@property (retain, nonatomic) NSURLResponse* urlResponse;
@property (retain, nonatomic) NSString* downloadFileName;
@property (nonatomic) BOOL isFinished;
@property(nonatomic,assign) int tag;

+(id) downloadFromURL:(NSString *) anURLString autoStart:(BOOL) autostart withDelegate:(id<DownloadDelegate>) delegate;
-(void) startDownload;
-(void) cancelDownload;
@end

Downloader *instance;