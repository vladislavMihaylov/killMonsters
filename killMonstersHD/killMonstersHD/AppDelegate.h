//
//  AppDelegate.h
//  killMonsters
//
//  Created by Mac on 06.08.12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushNotificationManager.h"
#import "ChartBoost.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, PushNotificationDelegate, ChartBoostDelegate> 
{
	UIWindow			*window;
	RootViewController	*viewController;
    
    UINavigationController *navigationController;
    PushNotificationManager *pushManager;
}

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) PushNotificationManager *pushManager;
@property (nonatomic, retain) UINavigationController *navigationController;

@end
