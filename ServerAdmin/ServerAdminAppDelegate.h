//
//  ServerAdminAppDelegate.h
//  ServerAdmin
//
//  Created by Roberto Hidalgo on 6/21/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SecurityInterface/SFAuthorizationView.h>

@interface ServerAdminAppDelegate : NSObject <NSApplicationDelegate> {
    AuthorizationRef myAuthorizationRef;
    OSStatus myStatus;
    Boolean autorizado;
    NSMutableDictionary *servicios;
    
    //botones
    IBOutlet NSButton *botonApache;
    IBOutlet NSButton *botonNginx;
    IBOutlet NSButton *botonMysql;
    IBOutlet NSButton *botonMongo;
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) NSButton *botonApache;
@property (assign) NSButton *botonNginx;
@property (assign) NSButton *botonMysql;
@property (assign) NSButton *botonMongo;
@property (nonatomic, retain) NSMutableDictionary *servicios;


- (void) ejecuta:(NSString *)tarea conArgumentos:(NSArray *)argumentos;
- (BOOL) status:(NSString *)servicio;
- (IBAction)apache:(id)sender;
- (void)apache:(id)sender ahuevo:(BOOL)ahuevo;
- (IBAction)nginx:(id)sender;
- (void)nginx:(id)sender ahuevo:(BOOL)ahuevo;
- (IBAction)mysql:(id)sender;
- (IBAction)mongo:(id)sender;

@end
