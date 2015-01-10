//
//  _MHImageBrowserCacheManager.m
//  MHImageBrowser
//
//  Created by Martin Hering on 09.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "_MHImageBrowserCacheManager.h"
#import "_MHImageThumbnailOperation.h"

@interface _MHImageBrowserCacheManager ()
@property (nonatomic, strong) NSOperationQueue* operationQueue;
@property (nonatomic, strong) NSMutableDictionary* thumbnailCache;
@end

@implementation _MHImageBrowserCacheManager

+ (_MHImageBrowserCacheManager *)sharedManager
{
    static dispatch_once_t once;
    static _MHImageBrowserCacheManager *singleton;
    dispatch_once(&once, ^ { singleton = [[_MHImageBrowserCacheManager alloc] init]; });
    return singleton;
}

- (instancetype) init
{
    if ((self = [super init]))
    {
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:5];
        _thumbnailCache = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSUInteger) thumbnailSizeForCellSize:(CGFloat)size
{
    NSUInteger i=(NSUInteger)size;;
    NSUInteger b=0;
    while (i > 0) {
        i = i >> 1;
        b++;
    }
    NSUInteger thumbnailSize = 1 << b;
    return MAX(128, thumbnailSize);
}

- (NSString*) cacheKeyForURL:(NSURL*)url thumbnailSize:(NSUInteger)size
{
    return [NSString stringWithFormat:@"%@_%lu", [url absoluteString], (long)size];
}

- (void) generateThumbnailForURL:(NSURL*)url size:(CGFloat)size completion:(void (^)(NSImage* thumbnail, BOOL async))completionBlock
{
    if (!completionBlock) {
        return;
    }
    
    NSUInteger thumbnailSize = [self thumbnailSizeForCellSize:size];
    NSString* cacheKey = [self cacheKeyForURL:url thumbnailSize:thumbnailSize];
    //NSLog(@"cacheKey %@", cacheKey);
    NSImage* cachedThumbnail = self.thumbnailCache[cacheKey];
    if (cachedThumbnail) {
        completionBlock(cachedThumbnail, NO);
        return;
    }
    
    
    _MHImageThumbnailOperation* operation = [[_MHImageThumbnailOperation alloc] initWithURL:url size:thumbnailSize];
    __weak _MHImageThumbnailOperation* weakOperation = operation;
    operation.completionBlock = ^() {
        _MHImageThumbnailOperation* strongOperation = weakOperation;
        if (!strongOperation.cancelled)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSImage* thumbnail = strongOperation.thumbnail;
                if (thumbnail) {
                    self.thumbnailCache[cacheKey] = thumbnail;
                }
                completionBlock(thumbnail, YES);
            });
        }
        
    };
    [self.operationQueue addOperation:operation];
}

- (void) cancelGeneratingThumbnailForURL:(NSURL*)url
{
    for (_MHImageThumbnailOperation* operation in self.operationQueue.operations)
    {
        if ([operation.url isEqualTo:url]) {
            [operation cancel];
        }
    }
}
@end
