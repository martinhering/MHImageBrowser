//
//  _MHMultiSizeImageCacheItem.m
//  MHImageBrowser
//
//  Created by Martin Hering on 11.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "_MHMultiSizeImageCacheItem.h"
@interface _MHMultiSizeImageCacheItem ()
@property (nonatomic, strong) NSMutableDictionary* images;
@end

@implementation _MHMultiSizeImageCacheItem

- (instancetype) init
{
    if ((self = [super init])) {
        _images = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void) addImage:(NSImage*)image withSize:(NSUInteger)size
{
    self.images[@(size)] = image;
}

- (NSImage*) imageWithSize:(NSUInteger)size
{
    return self.images[@(size)];
}

- (NSImage*) imageWithSizeClosestToSize:(NSUInteger)size
{
    NSImage* image = [self imageWithSize:size];
    if (image) {
        return image;
    }
    
    NSArray* allSizes = [[[[self.images allKeys] sortedArrayUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
    for(NSNumber* sizeValue in allSizes) {
        if ([sizeValue unsignedIntegerValue] < size) {
            NSLog(@"searching for %lu, using %lu", size, [sizeValue unsignedIntegerValue]);
            return self.images[sizeValue];
        }
    }
    return nil;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"<%@:0x%lx images=%@>", [self className], (long)self, [self.images description]];
}
@end
