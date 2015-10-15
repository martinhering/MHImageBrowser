//
//  _MHImageThumbnailOperation.m
//  MHImageBrowser
//
//  Created by Martin Hering on 09.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import "_MHImageThumbnailOperation.h"

#import <AVFoundation/AVFoundation.h>

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
    NSArray* videoSuffixes = @[@"mp4", @"m4v", @"mov"];
    if ([videoSuffixes containsObject:file.pathExtension.lowercaseString])
    {
        AVURLAsset *asset= [[AVURLAsset alloc] initWithURL:file options:nil];

        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = CGSizeMake(self.size, self.size);

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        __block CGImageRef thumbnail;
        [generator generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:kCMTimeZero]] completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error) {

            if (result == AVAssetImageGeneratorSucceeded) {
                thumbnail = CGImageCreateCopy(image);
            } else {
                NSLog(@"error generating image from asset: %@", error);
            }
            dispatch_semaphore_signal(semaphore);
        }];

        if (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) != 0) {
            NSLog(@"semaphore fail");
        }

        return thumbnail;
    }


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
