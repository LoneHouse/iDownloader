//
//  DownloadPool.h
//  iDownloader
//
//  Created by Roman on 18.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Downloader.h"

@interface DownloadPool : NSObject
@property ( nonatomic) NSMutableArray* pool;
-(Downloader*) addNewDownloadFromURL:(NSString*) url withDelegate:(id<DownloadDelegate>) delegate;
-(void) cancelAllDownloads;
-(void) cancelDownloadByURL:(NSString*) url;
-(void) cancelDownloadByTag:(NSInteger) tag;
@end
