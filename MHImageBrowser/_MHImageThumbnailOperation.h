//
//  _MHImageThumbnailOperation.h
//  MHImageBrowser
//
//  Created by Martin Hering on 09.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface _MHImageThumbnailOperation : NSOperation

- (instancetype) initWithURL:(NSURL*)url size:(NSUInteger)size;

@property (strong, readonly) NSURL* url;
@property (strong, readonly) NSImage* thumbnail;

@end
