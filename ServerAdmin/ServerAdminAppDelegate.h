//
//  ServerAdminAppDelegate.h
//  ServerAdmin
//
//  Created by Roberto Hidalgo on 6/21/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ServerAdminAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
