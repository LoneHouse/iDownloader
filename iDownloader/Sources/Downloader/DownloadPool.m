//
//  DownloadPool.m
//  iDownloader
//
//  Created by Roman on 18.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadPool.h"

@implementation DownloadPool
@synthesize pool;

static int tagCounter=0;

-(id)init{
    self=[super init];
    if(self){
        self.pool=[[NSMutableArray alloc]initWithCapacity:10]; 
		tagCounter=0;
    }
    return self;
}

-(Downloader*)addNewDownloadFromURL:(NSString *)url withDelegate:(id<DownloadDelegate>)delegate {
    //create new downloader
    Downloader* newDownloader=[Downloader downloadFromURL:url autoStart:NO withDelegate:delegate];
	newDownloader.tag=tagCounter++;
    //find place in pool
    int i;
    for(i=0;i<[self.pool count];i++)
    {
        Downloader* downloader=((Downloader*)[self.pool objectAtIndex:i]);
        if([self.pool objectAtIndex:i]==Nil || downloader.isFinished){
            [self.pool replaceObjectAtIndex:i withObject:newDownloader];
        }
    }
    
    //if place not founded then increment pool
    if(i==[self.pool count]){
		[self.pool addObject:newDownloader];
	}
    //start download
    [newDownloader startDownload];
    return [newDownloader autorelease];
}

-(void)cancelAllDownloads{
    for(int i=0;i<[self.pool count];i++)
    {
        Downloader* downloader=((Downloader*)[self.pool objectAtIndex:i]);
        if(!downloader.isFinished)
            [downloader cancelDownload];
    }
}

-(void) cancelDownloadByURL:(NSString *)url{
    for (int i=0; i<[self.pool count]; i++) {
        Downloader* downloader=((Downloader*)[self.pool objectAtIndex:i]);
        if([downloader.downloadURL isEqualToString:url]){
            [downloader cancelDownload];
            break;
        }
    }
}

-(void)cancelDownloadByTag:(NSInteger)tag{
	for (int i=0; i<[self.pool count]; i++) {
        Downloader* downloader=((Downloader*)[self.pool objectAtIndex:i]);
        if([downloader tag]==tag){
            [downloader cancelDownload];
            break;
        }
    }
}

-(void)dealloc{
    [super dealloc];
    [pool release];
}
@end
