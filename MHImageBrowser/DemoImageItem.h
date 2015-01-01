//
//  DemoImageItem.h
//  MHImageBrowser
//
//  Created by Martin Hering on 01.01.15.
//  Copyright (c) 2015 Martin Hering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHImageBrowserViewController.h"

@interface DemoImageItem : NSObject <MHImageBrowserImageItem>

@property (nonatomic, strong, readwrite) NSString* UID;
@property (nonatomic, assign, readwrite) MHImageBrowserImageItemRepresentationType representationType;
@property (nonatomic, strong, readwrite) id representation;
@property (nonatomic, assign, readwrite) NSUInteger version;
@property (nonatomic, strong, readwrite) NSString* title;
@property (nonatomic, strong, readwrite) NSString* subtitle;
@property (nonatomic, assign, readwrite, getter=isSelectable) BOOL selectable;

@end
