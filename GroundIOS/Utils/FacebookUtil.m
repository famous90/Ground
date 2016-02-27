//
//  FacebookUtil.m
//  GroundIOS
//
//  Created by Z's MacBookPro on 13. 8. 20..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#import "FacebookUtil.h"

@implementation FacebookUtil

static FacebookUtil *instance;

+ (FacebookUtil *)getInstance
{
    return instance;
}

+ (void)singleton
{
	instance = [[FacebookUtil alloc] init];
}

- (void)createNewSession
{
    FBSession* session = [[FBSession alloc] init];
    [FBSession setActiveSession: session];
}

- (void)openSessionWithCallback:(FacebookConnectionBlock)callback
{   
    NSLog(@"session = %@", [FBSession activeSession]);
    
    if([FBSession activeSession].state == FBSessionStateCreated || FBSessionStateCreatedTokenLoaded){
    
        NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
        
        // Attempt to open the session. If the session is not open, show the user the Facebook login UX
        [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:true
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState status,
                                                          NSError *error)
        {
            
            // Did something go wrong during login? I.e. did the user cancel?
            if (status == FBSessionStateClosedLoginFailed || status == FBSessionStateCreatedOpening) {
                
                // If so, just send them round the loop again
                [[FBSession activeSession] closeAndClearTokenInformation];
                [FBSession setActiveSession:nil];
                
                callback(NO, nil);
            }
            else{
                
                NSMutableDictionary *facebookInfo = [[NSMutableDictionary alloc] init];
                
                if ([FBSession activeSession].isOpen) {
                    
                    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection,
                                                                           NSDictionary<FBGraphUser> *user,
                                                                           NSError *error) {
                         
                         if (!error) {
                             
                             NSString* profileImageUrl = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=small", user.id];
                             
                             [facebookInfo setValue:user.name forKey:@"name"];
                             [facebookInfo setValue:[user valueForKey:@"email"] forKey:@"email"];
                             [facebookInfo setValue:profileImageUrl forKey:@"imageUrl"];
                             
                             //NSLog(@"facebook name = %@, email = %@, imageUrl = %@", user.name, [user valueForKey:@"email"], profileImageUrl);
                             
                             callback(YES, facebookInfo);
                         }
                         else{
                             
                             NSString *message = error.localizedDescription;
                             NSLog(@"error = %@", message);
                         }
                    }];
                    
                }
            }
        }];
    }
    else{
        
        NSLog(@"Failed to connect Facebook.");
    }
/*
    
    if ([FBSession activeSession]) {
        
        [FBRequest
        NSLog(@"session is already active.");
        // login is integrated with the send button -- so if open, we send
        //[self sendRequests];
        [self closeSession];
        [self openSessionWithCallback:callback];
    }
    else {

        [NSLog(@"session is not active.");
        
         [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES
         
        {
            // if login fails for any reason, we alert
            if(error) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                          message:error.localizedDescription
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
                [alert show];
                // if otherwise we check to see if the session is open, an alternative to
                // to the FB_ISSESSIONOPENWITHSTATE helper-macro would be to check the isOpen
                // property of the session object; the macros are useful, however, for more
                // detailed state checking for FBSession objects
            }
            else if (FB_ISSESSIONOPENWITHSTATE(status)) {
                
                // send our requests if we successfully logged in
                //[self sendRequests];
                NSLog(@"session = %@", session);
                NSLog(@"access token = %@", session.accessTokenData.accessToken);
                callback(YES, @{ @"access_token": session.accessTokenData.accessToken});
                
                FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
                NSLog(@"connection = %@", newConnection);
            }
        }];
    }

    FBSession *session = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance]];
    
    [FBSession setActiveSession:session];

    
    NSLog(@"session = %@", [FBSession activeSession]);
    NSLog(@"access token = %@", [FBSession activeSession].accessTokenData.accessToken);
    
    callback(YES, @{ @"access_token": [FBSession activeSession].accessTokenData.accessToken});

    
    // Attempt to open the session. If the session is not open, show the user the Facebook login UX
    [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:YES
                                                        completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
    {
        if(state == FBSessionStateOpen){
            
            NSLog(@"does work!!");
            
            NSLog(@"session = %@", session);
            NSLog(@"access token = %@", session.accessTokenData.accessToken);
            
            callback(YES, @{ @"access_token": session.accessTokenData.accessToken});
        }
        else if(state == FBSessionStateCreated){
            
            NSLog(@"session = %@", session);
            NSLog(@"access token = %@", session.accessTokenData.accessToken);
        }
        else{
            
            [self closeSession];
            
            if (error){
                
	            callback(NO, @{ @"error_message": error.localizedDescription});
            }else{
                
                callback(NO, nil);
            }
        }
    }];
     

    // ... and open it from the App Link's Token.
    [session openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  
                              }
                          }];
*/   
//    NSArray* readPermissions = [[NSArray alloc] initWithObjects:@"email", @"basic_info",nil];
    
   
    
//    if(session.state == FBSessionStateOpen){
//        
//        [self closeSession];
//        
//        NSLog(@"accessToken = %@", accessToken);
//        callback(YES, @{ @"access_token" : accessToken });
}

// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken
{
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:nil
                                                     permissions:nil
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance]];
    
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  
                              }
                          }];
}

- (void)closeSession
{
    [FBSession.activeSession closeAndClearTokenInformation];
}

- (void)applicationDidBecomeActive
{
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening){
        
        [FBSession.activeSession close]; // so we close our session and start over
    }
}

- (BOOL)handleOpenUrl:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

@end
