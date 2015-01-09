//
//  _MHImageBrowserCacheManager.h
//  MHImageBrowser
//
//  Created by Martin Hering on 09.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _MHImageBrowserCacheManager : NSObject

- (void) generateThumbnailForURL:(NSURL*)url size:(CGFloat)size completion:(void (^)(NSImage* thumbnail, BOOL async))completionBlock;
- (void) cancelGeneratingThumbnailForURL:(NSURL*)url;
@end
