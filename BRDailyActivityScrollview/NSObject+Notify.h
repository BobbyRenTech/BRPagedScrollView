//
//  NSObject+Notify.h
//  GymPact
//
//  Created by Bobby Ren on 12/17/13.
//  Copyright (c) 2013 Harvard University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Notify)

-(void)listenFor:(NSString *)notificationName action:(SEL)sel;
-(void)stopListeningFor:(NSString *)notificationName;

-(void)listenFor:(NSString *)notificationName action:(SEL)sel object:(id)obj;
-(void)stopListeningFor:(NSString *)notificationName object:(id)obj;

-(void)notify:(NSString *)notificationName;
-(void)notify:(NSString *)notificationName object:(id)obj userInfo:(NSDictionary *)userInfo;

// send a local notification in the form of an alert message
-(void)notifyAlert:(NSString *)alertMessage sound:(BOOL)sound;

@end
