//
//  ServerAdminAppDelegate.m
//  ServerAdmin
//
//  Created by Roberto Hidalgo on 6/21/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import "ServerAdminAppDelegate.h"

@implementation ServerAdminAppDelegate

@synthesize window;
@synthesize botonApache, botonMongo, botonMysql, botonNginx;
@synthesize servicios;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    // Insert code here to initialize your application
    autorizado = NO;
    NSArray *keys = [NSArray arrayWithObjects: @"apache", @"nginx", @"mysql", @"mongo" ,nil];
    NSArray *vals = [NSArray arrayWithObjects: @"false", @"false", @"false", @"false" ,nil];
    servicios = [[NSMutableDictionary alloc] initWithObjects:vals forKeys:keys ];
        
    NSString *command = @"/bin/ps";
    NSTask *checa = [[NSTask alloc] init];
    [checa setLaunchPath: command];
    [checa setArguments:[NSArray arrayWithObjects:@"aux", nil]];
    NSPipe *pipe = [NSPipe pipe];
    [checa setStandardOutput: pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    [checa launch];
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *procesos;
    procesos = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];    
    
    for (NSString *key in [servicios allKeys]) {
        
        NSString *nombreBoton = [NSString stringWithFormat:@"boton%@", key.capitalizedString];
        
        if ([procesos rangeOfString:key].location != NSNotFound) {
            //encendido
            [[self valueForKey:nombreBoton] setState:NSOnState];
            [servicios setValue:@"true" forKeyPath:key];
        } else {
            //apagado
            [[self valueForKey:nombreBoton] setState:NSOffState];
        }
        
    }
    
}



- (BOOL)status:(NSString *)servicio {
    NSLog(@"%@ %@: %@", @"status", servicio, [servicios valueForKey:servicio]);
    return [servicios valueForKey:servicio]==@"true";
}

- (void)autoriza {
    if( autorizado ){
        return;
    } else {
        AuthorizationFlags myFlags = kAuthorizationFlagDefaults;
        myStatus = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, myFlags, &myAuthorizationRef);
        AuthorizationItem myItems = {kAuthorizationRightExecute, 0, NULL, 0};
        AuthorizationRights myRights = {1, &myItems};
        myFlags = kAuthorizationFlagDefaults | 
        kAuthorizationFlagInteractionAllowed |
        kAuthorizationFlagPreAuthorize |
        kAuthorizationFlagExtendRights;
        myStatus = AuthorizationCopyPrivilegedReference (&myAuthorizationRef,kAuthorizationFlagDefaults);
        myStatus = AuthorizationCopyRights (myAuthorizationRef,&myRights, NULL, myFlags, NULL ); 
        autorizado = YES;
    }
}


- (void) ejecuta:(NSString *)path conArgumentos:(NSArray *)argumentos {
    
    NSMutableArray *args = [[NSMutableArray alloc] init];
    [args addObject:path];
    
    if( [argumentos objectAtIndex:0]!=@" " ){
        [args addObjectsFromArray:argumentos];
    }
    
    const char **argv = (const char **)malloc(sizeof(char *) * [args count] + 1);
    int argvIndex = 0;
    for (NSString *string in args) {
        argv[argvIndex] = [string UTF8String];
        argvIndex++;
    }
    argv[argvIndex] = nil;

           
    NSLog(@"Llamando %@ con %@", path, argumentos);
    
    [self autoriza];
    
    NSString *pwd = [[NSBundle mainBundle] bundlePath];
    NSString *taskero = [[NSString alloc] initWithFormat:@"%@/Contents/Resources/%@", pwd, @"task"];
    
    FILE *pipe = NULL;
    myStatus = AuthorizationExecuteWithPrivileges(myAuthorizationRef, [taskero UTF8String], kAuthorizationFlagDefaults, (char *const *)argv ,&pipe);
}


- (IBAction) apache:(id)sender
{
    NSString *servicio = @"apache";
    
    Boolean ahora;
    NSArray *arguments;
    NSString *tarea = @"/usr/sbin/apachectl";
    if( [self status:servicio]==true ){
        ahora = NO;
        arguments = [NSArray arrayWithObject: @"stop"]; 
    } else {
        [self nginx:sender ahuevo:YES];
        ahora = YES;
        arguments = [NSArray arrayWithObject: @"start"];
    }
    [servicios setValue:(ahora? @"true" : @"false") forKey:servicio];
    [self ejecuta: tarea conArgumentos:arguments];
}
- (void)apache:(id)sender ahuevo:(BOOL)ahuevo
{
    [servicios setValue:@"false" forKey:@"apache"];
    [self ejecuta: @"/usr/sbin/apachectl" conArgumentos:[NSArray arrayWithObjects: @"stop", nil]];
    [botonApache setState:NSOffState];
}



- (IBAction) nginx:(id)sender
{
    NSString *servicio = @"nginx";
    
    Boolean ahora;
    NSArray *arguments;
    NSString *tarea = @"/usr/local/bin/nginx";
    if( [self status:servicio]==false ){
        ahora = YES;
        if( [self status:@"apache"]==true ) {
            [self apache:sender ahuevo:YES];
        }
        arguments = [NSArray arrayWithObjects: @"-c", @"/etc/nginx/nginx.conf", nil];
        [self ejecuta:@"/usr/local/sbin/php-fpm" conArgumentos:[NSArray arrayWithObjects: @" ", nil]];
    } else {
        ahora = NO;
        arguments = [NSArray arrayWithObjects: @"-s", @"stop", nil];
        [self ejecuta:@"/usr/bin/killall" conArgumentos:[NSArray arrayWithObjects: @"php-fpm", nil]];
    }
    [servicios setValue:(ahora? @"true" : @"false") forKey:servicio];
    [self ejecuta: tarea conArgumentos:arguments];
}

- (void)nginx:(id)sender ahuevo:(BOOL)ahuevo
{
    [self ejecuta:@"/usr/bin/killall" conArgumentos:[NSArray arrayWithObjects: @"php-fpm", nil]];
    [servicios setValue:@"false" forKey:@"nginx"];
    [self ejecuta: @"/usr/local/bin/nginx" conArgumentos:[NSArray arrayWithObjects: @"-s", @"stop", nil]];
    [botonNginx setState:NSOffState];
}


- (IBAction) mysql:(id)sender
{
    NSString *servicio = @"mysql";
    
    Boolean ahora;
    NSArray *arguments;
    NSString *pwd = [[NSBundle mainBundle] bundlePath];
    NSString *tarea = [[NSString alloc] initWithFormat:@"%@/Contents/Resources/%@", pwd, @"mysql.sh"];
    if( [self status:servicio]==false ){
        ahora = YES;
        arguments = [NSArray arrayWithObjects: @"start", nil];
    } else {
        ahora = NO;
        arguments = [NSArray arrayWithObjects: @"stop", nil];
    }
    [servicios setValue:(ahora? @"true" : @"false") forKey:servicio];
    [self ejecuta: tarea conArgumentos:arguments];
    
}

- (IBAction) mongo:(id)sender
{
    NSString *servicio = @"mongo";
    
    Boolean ahora;
    if( [self status:servicio]==false ){
        ahora = YES;
        NSString *tarea = @"/usr/local/mongo/bin/mongod";
        NSArray *arguments;
        arguments = [NSArray arrayWithObjects: @"-f", @"/etc/mongo.conf", @"--fork", nil];
        [self ejecuta:tarea conArgumentos:arguments];
    } else {
        ahora = NO;
        [self ejecuta:@"/usr/bin/killall" conArgumentos:[NSArray arrayWithObjects: @"mongod", nil]];
    }
    [servicios setValue:(ahora? @"true" : @"false") forKey:servicio];
}


- (void) dealloc
{
    [servicios release];
    [botonApache release];
    [botonMongo release];
    [super dealloc];
}

@end
