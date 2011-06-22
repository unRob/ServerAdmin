//
//  task.cpp
//  ServerAdmin
//
//  Created by Roberto Hidalgo on 6/22/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//
/*#import <Foundation/Foundation.h>
 
int main (void) {
     NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
     
     //Changing the uid
     setuid(0);
     
     //NSLog(@"ruid: %d\n", getuid());
     //NSLog(@"euid: %d\n", geteuid());
     
     NSMutableArray *args = [[NSProcessInfo processInfo] arguments];
     [ args removeObjectAtIndex:0 ];
     
     NSString *task = [args objectAtIndex:0];
     
     [ args removeObjectAtIndex:0 ];
     NSLog(@"args: %@", args);
     
     // Launching airport, normally, here, i'm root...
     NSTask *airport = [[NSTask alloc] init];
     [airport setLaunchPath: task];
     [airport setArguments: args];
     
     [airport launch];
     [pool drain];
     return 0;
}*/