//
//  NSObject+Notify.m
//  GymPact
//
//  Created by Bobby Ren on 12/17/13.
//  Copyright (c) 2013 Harvard University. All rights reserved.
//

#import "NSObject+Notify.h"

@implementation NSObject (Notify)

-(void)listenFor:(NSString *)notificationName action:(SEL)sel {
    [self listenFor:notificationName action:sel object:nil];
}

-(void)listenFor:(NSString *)notificationName action:(SEL)sel object:(id)obj {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:sel name:notificationName object:obj];
}

-(void)stopListeningFor:(NSString *)notificationName {
    [self stopListeningFor:notificationName object:nil];
}

-(void)stopListeningFor:(NSString *)notificationName object:(id)obj {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:obj];
}

-(void)notify:(NSString *)notificationName {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:nil];
}

-(void)notify:(NSString *)notificationName object:(id)obj userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:obj userInfo:userInfo];
}

-(void)notifyAlert:(NSString *)alertMessage sound:(BOOL)sound {
    UILocalNotification *warning = [[UILocalNotification alloc] init];
    if (sound)
        warning.soundName = UILocalNotificationDefaultSoundName;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        warning.applicationIconBadgeNumber = 1;
    }
    warning.alertBody = alertMessage;
    [[UIApplication sharedApplication] presentLocalNotificationNow:warning];
}
@end
