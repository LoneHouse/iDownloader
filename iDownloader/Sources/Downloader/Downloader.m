//
//  Downloader.m
//  iDownloader
//
//  Created by Roman on 17.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Downloader.h"

#define callDelegateMethod(method,parameter) if(instance.delegate && [instance.delegate respondsToSelector:@selector(method)]) [instance.delegate performSelector:@selector(method) withObject:parameter];
#define callDelegateMethodWithParameters(method,parameterOne, parameterTwo) if(instance.delegate && [instance.delegate respondsToSelector:@selector(method)]) [instance.delegate performSelector:@selector(method) withObject:parameterOne withObject:parameterTwo];

@implementation Downloader
@synthesize downloadURL;
@synthesize urlConnection;
@synthesize delegate;
@synthesize downloadedData;
@synthesize urlResponse;
@synthesize downloadFileName;
@synthesize isFinished,tag;

static dispatch_queue_t queue;


+(id)downloadFromURL:(NSString *)anURLString autoStart:(BOOL)autostart withDelegate:(id<DownloadDelegate>) delegate{
    instance=[[Downloader alloc]init];
    instance.downloadURL=anURLString;
    instance.delegate=delegate;
    if(autostart)
        [instance startDownload];
    return instance;
}

-(id)init{
    self=[super init];
    if (self){
       queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

-(void)startDownload{
	Reachability *reachability = [Reachability reachabilityForInternetConnection];  
    NetworkStatus networkStatus = [reachability currentReachabilityStatus]; 
    if(networkStatus != NotReachable){
		
		//convert string to url
		NSURL * url= [NSURL URLWithString:self.downloadURL];
		if(!url){
			NSString *errorText=[NSString stringWithFormat:@"Could not create URL from string: %@",self.downloadURL];
			callDelegateMethodWithParameters(didDownloadFailed:withError:, self, errorText);
			return;
		}
		
		//create request from url
		NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
		if (!request) {
			NSString *errorText=[NSString stringWithFormat:@"Could not create request from URL: %@",self.downloadURL];
			callDelegateMethod(didDownloadFailed:,errorText);
			return;
			
		}
		//create connection from url
		self.urlConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		if (!self.urlConnection) {
			NSString *errorText=[NSString stringWithFormat:@"Could not create URL connnection: %@",self.downloadURL];
			callDelegateMethodWithParameters(didDownloadFailed:withError:, self, errorText);
			return;
		}
		
		self.downloadedData=[[NSMutableData alloc]init];
		
		//start download at new thread
		dispatch_async(queue, ^{
			isFinished=NO;
			[self.urlConnection start];
			NSLog(@"endThread");
		});
		
		//[self.urlConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
		//call delegate
		callDelegateMethod(didStartDownload:, self);
	}
	else {
		NSString *errorText=[NSString stringWithFormat:@"Internet connection is unreachable. Downloading file by url was canceled!",self.downloadURL];
		callDelegateMethodWithParameters(didDownloadFailed:withError:, self, errorText);
	}
}


-(void)cancelDownload{
    [self.urlConnection cancel];
    callDelegateMethod(didDownloadCancel:, self);
    self.isFinished=YES;
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    //append data
    [self.downloadedData appendData:data];
    //NSLog(@"Received %d bytes", data.length);
    
    if (self.urlResponse)
    {
        //get downloaded percent
        float expectedLength = [self.urlResponse expectedContentLength];
        float currentLength = self.downloadedData.length;
        float percent = currentLength / expectedLength*100;
        callDelegateMethodWithParameters(didProgressDownload:withPercents:, self, [NSNumber numberWithFloat:percent]);
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.urlResponse=response;
    if(response.suggestedFilename){
        self.downloadFileName=response.suggestedFilename;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if([self.urlResponse expectedContentLength]==[self.downloadedData length]){
		callDelegateMethod(didFinishDownload:, self);

	}
	else
	{
		callDelegateMethodWithParameters(didDownloadFailed:withError:,self, @"Downloaded data corrupted! Probably internet connection failed!");
		NSLog(@"Downloaded data corrupted! Probably internet connection failed!");
	}
		self.isFinished=YES;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    //call delegate method
    callDelegateMethodWithParameters(didDownloadFailed:withError:,self, error.localizedDescription);
    NSLog(@"%@",error.localizedDescription);
    self.isFinished=YES;
}

@end
