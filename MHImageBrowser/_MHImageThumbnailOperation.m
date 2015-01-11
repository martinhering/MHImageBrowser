//
//  _MHImageThumbnailOperation.m
//  MHImageBrowser
//
//  Created by Martin Hering on 09.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "_MHImageThumbnailOperation.h"

@interface _MHImageThumbnailOperation ()
@property (strong, readwrite) NSURL* url;
@property (assign, readwrite) NSUInteger size;
@property (strong, readwrite) NSImage* thumbnail;
@end

@implementation _MHImageThumbnailOperation

- (instancetype) initWithURL:(NSURL*)url size:(NSUInteger)size
{
    if ((self = [self init]))
    {
        _url = url;
        _size = size;
    }
    
    return self;
}

- (CGImageRef) imageWithFileURL:(NSURL*)file
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)file, NULL);
    if (!imageSource) {
        NSLog(@"image source is invalid: %@", self.url);
        return nil;
    }
    
    CFStringRef type = CGImageSourceGetType(imageSource);
    
    // check if type is readable by Image I/O
    if (!type) {
        CFRelease(imageSource);
        return nil;
    }
    
    NSDictionary* options = @{ (__bridge NSString*)kCGImageSourceThumbnailMaxPixelSize : @(self.size),
                               (__bridge NSString*)kCGImageSourceCreateThumbnailFromImageAlways : @(YES),
                               (__bridge NSString*)kCGImageSourceCreateThumbnailWithTransform : @(YES)
                               };
    
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex (imageSource, 0, (__bridge CFDictionaryRef)options);
    CFRelease(imageSource);
    return thumbnail;
}

- (void) main
{
    @autoreleasepool {
        
        if (self.cancelled) {
            return;
        }

        if ([self.url isFileURL])
        {
            CGImageRef imageRef = [self imageWithFileURL:self.url];
            if (imageRef) {
                self.thumbnail = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
                CFRelease(imageRef);
                imageRef = NULL;
            }
        }
    }
}
@end
