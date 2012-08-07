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
@property ( nonatomic) NSString* downloadURL;
@property ( nonatomic) id<DownloadDelegate> delegate;
@property ( nonatomic) NSURLConnection* urlConnection;
@property ( nonatomic) NSMutableData* downloadedData;
@property ( nonatomic) NSURLResponse* urlResponse;
@property ( nonatomic) NSString* downloadFileName;
@property (nonatomic) BOOL isFinished;
@property(nonatomic,assign) int tag;

+(id) downloadFromURL:(NSString *) anURLString autoStart:(BOOL) autostart withDelegate:(id<DownloadDelegate>) delegate;
-(void) startDownload;
-(void) cancelDownload;
@end

Downloader *instance;