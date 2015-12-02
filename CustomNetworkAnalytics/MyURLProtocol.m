//
//  MyURLProtocol.m
//  CustomNetworkAnalytics
//
//  Created by Anthony Oliveri on 4/17/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

#import "MyURLProtocol.h"
#import "WLAnalytics.h"
#import "OCLogger.h"

@interface MyURLProtocol() <NSURLConnectionDataDelegate>

@property NSURLConnection* connection;
@property NSString* analyticsTrackingId;

@end



@implementation MyURLProtocol

#pragma mark NSURLProtocol

+ (BOOL) canInitWithRequest:(NSURLRequest *)request {
    NSLog(@"REQUEST URL: %@", request.URL.absoluteString);
    NSString* allowedURL = @"https://www.google.com/maps";
    
    if ( [request.URL.absoluteString isEqualToString:allowedURL] ) {
        if ( ! [NSURLProtocol propertyForKey:@"MyURLProtocolHandledKey" inRequest:request]) {
            return YES;
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    NSDictionary* analyticsRequestMetadata = [[WLAnalytics sharedInstance] generateNetworkRequestMetadataWithURL:@"https://www.google.com/maps"];
    self.analyticsTrackingId = analyticsRequestMetadata[@"$trackingid"];
    [[WLAnalytics sharedInstance] log:@"Google Maps network request" withMetadata:analyticsRequestMetadata];
    
    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:@"MyURLProtocolHandledKey" inRequest:newRequest];
    
    self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
}

- (void)stopLoading {
    [[WLAnalytics sharedInstance] send];
    [self.connection cancel];
    self.connection = nil;
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSDictionary* analyticsResponseMetadata = [[WLAnalytics sharedInstance] generateNetworkResponseMetadataWithResponseData:data andTrackingId:self.analyticsTrackingId];
    [[WLAnalytics sharedInstance] log:@"Google Maps network response" withMetadata:analyticsResponseMetadata];
    
    [self.client URLProtocol:self didLoadData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}

@end
