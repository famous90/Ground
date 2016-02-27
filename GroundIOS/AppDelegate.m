//
//  AppDelegate.m
//  GroundIOS
//
//  Created by 잘생긴 규영이 on 13. 7. 7..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginSelectViewController.h"
#import "MyNewsParentViewController.h"
#import "ChatViewController.h"
#import "DetailMatchViewController.h"
#import "TeamTabbarParentViewController.h"
#import "MatchsViewController.h"
#import "StartManualViewController.h"
#import "AwayTeamInfoInMatchViewController.h"

#import "StartManualViewController.h"

#import "User.h"
#import "TeamHint.h"
#import "Match.h"

#import "GroundClient.h"
#import "LocalUser.h"

#import "FacebookUtil.h"
#import "Util.h"
#import "ViewUtil.h"
#import "sys/utsname.h"
#import "GAI.h"

@implementation AppDelegate{
    NSArray *pages;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
#ifdef DEBUG
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-45778417-2"];
#else
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-45778417-1"];
#endif
    
    // Local 기본정보 세팅.
    [[LocalUser getInstance] setLocalUserInfo];
    
    // SET application NAVIGATION appearance
    UIImage *navBackgroundImage;
    // ios6이하
    if([LocalUser getInstance].deviceOSVer < 7){
        navBackgroundImage = [UIImage imageNamed:@"navigationBar_bg"];
        [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setTintColor:UIColorFromRGB(0x1B252E)];

    // ios7
    }else{
        navBackgroundImage = [UIImage imageNamed:@"navigationBar_ios7_bg"];
        [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xFFFFFF), UITextAttributeTextColor, UIFontFixedFontWithSize(15.5), UITextAttributeFont, nil]];
//        [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(0xffffff), UITextAttributeTextColor, UIFontFixedFontWithSize(10), UITextAttributeFont, nil] forState:UIControlStateNormal];
    }
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if(userInfo != nil){
        [self pushEvent:userInfo];
    }
    
    // sessionkey 있을 경우, 바로 뉴스피드화면으로...
    [self sessionCheck];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

- (void)sessionCheck
{
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    if([LocalUser getInstance].sessionKey){
        
        // APNS에 디바이스를 등록한다. - Push Notification
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeAlert|
         UIRemoteNotificationTypeBadge|
         UIRemoteNotificationTypeSound];
        
        [[GroundClient getInstance] getUserInfo:[LocalUser getInstance].userId callback:^(BOOL result, NSDictionary *data) {
            if(result){
                MyNewsParentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
                [self.window setRootViewController:viewController];
            }else{
                [[LocalUser getInstance] logout];
                LoginSelectViewController *initViewController = (LoginSelectViewController *)[storyboard instantiateInitialViewController];
                [self.window setRootViewController:initViewController];
            }
        }];
    }
    else{
        StartManualViewController *initViewController = (StartManualViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StartManualView"];
        [self.window setRootViewController:initViewController];
    }
}


# pragma mark - facebook authentication + kakaotalk invitation
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // kakaotalk invitation
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    
    if([[[url absoluteString] substringToIndex:12]isEqualToString:@"GroundIOS://"]){
        NSString *kakaoUrl = [url absoluteString];
        NSLog(@"length = %d", kakaoUrl.length);
        
        if(kakaoUrl.length <13){
            [self sessionCheck];

        }else{
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            
            if([LocalUser getInstance].sessionKey){
                NSInteger teamId = [[kakaoUrl substringFromIndex:19] integerValue];
                User *user = [[User alloc] initWithUserId:[LocalUser getInstance].userId name:[LocalUser getInstance].userName imageUrl:[LocalUser getInstance].userImageUrl];
                
                MyNewsParentViewController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
                rootViewController.user = user;
                
                UINavigationController *navController = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"AwayTeamInfoInMatchNavigationViewController"];
                AwayTeamInfoInMatchViewController *childViewController = (AwayTeamInfoInMatchViewController *)[navController topViewController];
                childViewController.user = user;
                childViewController.competitorTeamId = teamId;
                childViewController.pageoOriginType = VIEW_FROM_TEAMURL_INVITE;
                
                [self.window setRootViewController:rootViewController];
                [self.window makeKeyAndVisible];
                [rootViewController presentViewController:navController animated:YES completion:NULL];

            }else{
                NSLog(@"no session");
                
                [[LocalUser getInstance] logout];
                LoginSelectViewController *initViewController = (LoginSelectViewController *)[storyboard instantiateInitialViewController];
                [Util showAlertView:initViewController message:@"로그인 후, 다시 카카오톡 링크를 클릭하세요."];
                [self.window setRootViewController:initViewController];
                [self.window makeKeyAndVisible];
            }
        }
    }
    
    //facebook connection
    return [[FBSession activeSession] handleOpenURL:url];
}

# pragma mark - push notification

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSMutableString *deviceId = [NSMutableString string];
    const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
    
    for(int i = 0 ; i < 32 ; i++)
    {
        [deviceId appendFormat:@"%02x", ptr[i]];
    }
    
    // pushToken 등록.
    NSLog(@"APNS Device Token: %@", deviceId);
    [[LocalUser getInstance] setPushToken:deviceId];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo = %@", userInfo);
    
    if ( application.applicationState != UIApplicationStateActive )
    {
        [self pushEvent:userInfo];
    }
}

- (void)pushEvent:(NSDictionary*)pushInfo
{
    NSString *pushType = [[[pushInfo valueForKey:@"aps"] objectForKey:@"alert"] valueForKey:@"loc-key"];
    NSInteger badge = [[[pushInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    NSInteger matchId = [[pushInfo valueForKey:@"matchId"] integerValue];
    NSInteger teamId = [[pushInfo valueForKey:@"teamId"] integerValue];
    
    UIStoryboard *storyboard = [ViewUtil storyboardForiPhoneDeviceScreenHeight];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if([LocalUser getInstance].sessionKey){
        [[GroundClient getInstance] getUserInfo:[LocalUser getInstance].userId callback:^(BOOL result, NSDictionary *data) {
            if(result){
                NSDictionary *userInfo = [data objectForKey:@"userInfo"];
                User *user = [[User alloc] initWithUserId:[[userInfo valueForKey:@"userId"] integerValue] name:[userInfo valueForKey:@"name"] imageUrl:[userInfo valueForKey:@"profileImageUrl"]];
                
                [[GroundClient getInstance] getTeamHintWithTeamId:teamId callback:^(BOOL result, NSDictionary *data){
                    if(result) {
                        TeamHint *teamHint = [[TeamHint alloc] initWithTeamData:[data objectForKey:@"teamHint"]];
                        
                        if([pushType isEqual:PUSHKEY_DENY_MATCH]){
                            TeamTabbarParentViewController *childViewController = (TeamTabbarParentViewController *)[storyboard instantiateViewControllerWithIdentifier:@"TeamTabbarParentViewController"];
                            childViewController.user = user;
                            childViewController.teamHint = teamHint;
                            childViewController.tabbarSelectedIndex = TABBAR_INDEX_MATCH;
                            
                            [self.window setRootViewController:childViewController];
                            [self.window makeKeyAndVisible];
                            
                        }else{
                            MatchsViewController *rootViewController = (MatchsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"MatchsViewController"];
                            rootViewController.user = user;
                            rootViewController.teamHint = teamHint;

                            UINavigationController *navController = [storyboard instantiateViewControllerWithIdentifier:@"DetailMatchNavigationViewController"];
                            DetailMatchViewController *childViewController = (DetailMatchViewController *)[navController topViewController];
                            childViewController.user = user;
                            childViewController.teamHint = teamHint;
                            childViewController.match.matchId = matchId;
                            childViewController.pageOriginType = VIEW_FROM_PUSHMESSAGE;
                            
                            [self.window setRootViewController:rootViewController];
                            [self.window makeKeyAndVisible];
                            [rootViewController presentViewController:navController animated:YES completion:NULL];
                        }
                    }else{
                        NSLog(@"error to load team hint in app delegate");
                        [Util showErrorAlertView:nil message:@"푸시 정보를 불러오지 못했습니다"];
                        MyNewsParentViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"MyNewsParentViewController"];
                        [self.window setRootViewController:viewController];
                        [self.window makeKeyAndVisible];
                        
                    }
                }];
                
            }else{
                [[LocalUser getInstance] logout];
                LoginSelectViewController *initViewController = (LoginSelectViewController *)[storyboard instantiateInitialViewController];
                [self.window setRootViewController:initViewController];
                [self.window makeKeyAndVisible];
            }
        }];
    }
    else{
        LoginSelectViewController *initViewController = (LoginSelectViewController *)[storyboard instantiateInitialViewController];
        [self.window setRootViewController:initViewController];
        [self.window makeKeyAndVisible];

    }
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GroundIOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GroundIOS.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
