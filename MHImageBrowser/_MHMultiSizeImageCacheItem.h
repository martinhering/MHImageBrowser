//
//  _MHMultiSizeImageCacheItem.h
//  MHImageBrowser
//
//  Created by Martin Hering on 11.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _MHMultiSizeImageCacheItem : NSObject

- (void) addImage:(NSImage*)image withSize:(NSUInteger)size;
- (NSImage*) imageWithSize:(NSUInteger)size;
- (NSImage*) imageWithSizeClosestToSize:(NSUInteger)size;

@end
