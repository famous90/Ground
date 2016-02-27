//
//  ChatViewController.m
//  GroundIOS
//
//  Created by Gyuyoung Hwang on 2013. 11. 8..
//  Copyright (c) 2013년 AnB. All rights reserved.
//

#define COMPETITIVE_TEAM_MESSAGE_CELL   0
#define OUR_TEAM_MESSAGE_CELL           1

#define PADDING 9
#define CHAT_MESSAGE_CONSTRAINT CGSizeMake(181, 10000)

#define ACKED_CHAT_SECTION  0
#define NACKED_CHAT_SECTION 1

#import "ChatViewController.h"
#import "LoadingView.h"

#import "User.h"
#import "TeamHint.h"
#import "ChatMessage.h"
#import "ChatDataController.h"

#import "GroundClient.h"
#import "LocalUser.h"
#import "SBJson.h"
#import "IMRequest.h"

#import "Util.h"
#import "ViewUtil.h"

#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation ChatViewController{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    
    NSInteger chatMessageCur;
    NSInteger NACKedChatNum;
    ChatDataController *chatDataController;
    ChatDataController *checkingChatACKDataController;
    NSArray *teamImageArray;
    
    CGFloat sumRowHeight;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.user = [[User alloc] init];
    self.teamHint = [[TeamHint alloc] init];
    self.competitiveTeamHint = [[TeamHint alloc] init];
    self.myTeamImage = [[UIImage alloc] init];
    self.competitiveTeamImage = [[UIImage alloc] init];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[[GAI sharedInstance] defaultTracker] set:kGAIScreenName value:NSStringFromClass([self class])];
    [[[GAI sharedInstance] defaultTracker] send:[[GAIDictionaryBuilder createAppView] build]];
    
    sumRowHeight = 0.0f;
    chatMessageCur = 0;
    NACKedChatNum = 0;
    chatDataController = [[ChatDataController alloc] init];
    checkingChatACKDataController = [[ChatDataController alloc] init];
    teamImageArray = [[NSArray alloc] initWithObjects:self.competitiveTeamImage, self.myTeamImage, nil];
    
    [self loadMessageHistory];
    [self initSocketConnectionWithDeviceUuid:[[LocalUser getInstance] deviceUuid]];
}

- (void)loadMessageHistory
{
    LoadingView *loadingView = [LoadingView startLoading:@"지난 메세지를 불러오고 있습니다" parentView:self.view];
    
    [[GroundClient getInstance] getMessageList:self.matchId teamId:self.teamHint.teamId cur:chatMessageCur callback:^(BOOL result, NSDictionary *data)
     {
         if(result){
             
             NSArray* messageList = [data objectForKey:@"messageList"];
             for(id obejct in messageList){
                 ChatMessage *theChatMessage = [[ChatMessage alloc] initWithData:obejct];
                 [chatDataController addChatMessageWithData:theChatMessage];
             }
             [chatDataController sortChatMessageById];
//             chatMessageCur = [chatDataController getBottomMessageId];
             [self.chattingTableView reloadData];
             
//             NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[chatDataController countOfList]-1 inSection:0];
//             [self.chattingTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
             [self.chattingMessageTextField becomeFirstResponder];
         }else{
             NSLog(@"error to load chat message in chat");
             [Util showAlertView:nil message:[NSString stringWithFormat:@"채팅에 문제가 발생했습니다.\r\n아래 번호로 연락주시면 해결해드리겠습니다.\r\n%@", CHAT_PROBLEM_MANAGER_PHONE_NUMBER]];
         }
         
         [loadingView stopLoading];
     }];
}

- (void)initSocketConnectionWithDeviceUuid:(NSString*)deviceUuid
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"altair.vps.phps.kr", 8999, &readStream, &writeStream);
    
    inputStream = (__bridge_transfer NSInputStream *)readStream;
    outputStream = (__bridge_transfer NSOutputStream *)writeStream;
    
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];

    [outputStream setDelegate:self];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream open];
    
    NSString *keyStr = [NSString stringWithFormat:@"%@\n", deviceUuid];
    NSData *keyData = [[NSData alloc] initWithData:[keyStr dataUsingEncoding:NSASCIIStringEncoding]];
    
    //    NSLog(@"keyStr = %@, keyData = %@", keyStr, keyData);
    [outputStream write:(const uint8_t *)[keyData bytes] maxLength:[keyData length]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CancelChatting"]) {
        [self closeSocket];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Implementation
- (void)closeSocket
{
    if (outputStream != nil) {
        [outputStream close];
        [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    if (inputStream != nil) {
        [inputStream close];
        [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == ACKED_CHAT_SECTION) {
        return [chatDataController countOfList];
        
    }else if (section == NACKED_CHAT_SECTION){
        return [checkingChatACKDataController countOfList];
        
    }else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessage *theChatMessage;
    UIImage *waitACKImage;
    
    if (indexPath.section == ACKED_CHAT_SECTION) {
        theChatMessage = [chatDataController objectInMasterDataAtIndex:indexPath.row];
        waitACKImage = [UIImage imageNamed:@"detailMatch_join_icon"];
        
    }else if (indexPath.section == NACKED_CHAT_SECTION){
        theChatMessage = [checkingChatACKDataController objectInMasterDataAtIndex:indexPath.row];
        waitACKImage = [UIImage imageNamed:@"chat_send_icon"];
    }
    
    NSInteger cellArrayIndex;
    if (theChatMessage.teamId == self.competitiveTeamHint.teamId) {
        cellArrayIndex = COMPETITIVE_TEAM_MESSAGE_CELL;
    }else{
        cellArrayIndex = OUR_TEAM_MESSAGE_CELL;
    }
    
    NSArray *cellIdentifierArray = [[NSArray alloc] initWithObjects:@"CompetitiveMessageCell", @"OurMessageCell", nil];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[cellIdentifierArray objectAtIndex:cellArrayIndex] forIndexPath:indexPath];
    if (cell == Nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[cellIdentifierArray objectAtIndex:cellArrayIndex]];
    }
    
    NSArray *cellTagArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:6000], [NSNumber numberWithInt:6010], nil];
    NSInteger tag = [[cellTagArray objectAtIndex:cellArrayIndex] integerValue];
    NSArray *cellImageOriginArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:4], [NSNumber numberWithFloat:280], nil];
    
    tag++;
//    UIImageView *teamImageView = (UIImageView *)[cell viewWithTag:tag++];
    UILabel *teamNameLabel = (UILabel *)[cell viewWithTag:tag++];
    UITextView *teamChatMessageTextView = (UITextView *)[cell viewWithTag:tag++];
    UIImageView *ourTeamWaitACKImageView;
    if (cellArrayIndex == OUR_TEAM_MESSAGE_CELL) {
        ourTeamWaitACKImageView = (UIImageView *)[cell viewWithTag:tag++];
        ourTeamWaitACKImageView.image = waitACKImage;
    }
    
//    [teamImageView setAutoresizesSubviews:NO];
//    CGRect teamImageViewNewFrame = teamImageView.frame;
//    teamImageViewNewFrame = CGRectMake(teamImageView.frame.origin.x, teamImageView.frame.origin.y, 36, 36);
//    teamImageView.frame = teamImageViewNewFrame;
    
    CGSize messageSize = [theChatMessage.message sizeWithFont:UIFontHelveticaWithSize(14) constrainedToSize:CHAT_MESSAGE_CONSTRAINT lineBreakMode:NSLineBreakByCharWrapping];
    CGRect chatMessageNewFrame = teamChatMessageTextView.frame;
    CGRect waitACKImageViewNewFrame = ourTeamWaitACKImageView.frame;
    
    if (cellArrayIndex == OUR_TEAM_MESSAGE_CELL){
        chatMessageNewFrame.origin.x = cell.frame.size.width - (messageSize.width + PADDING*2) - 43;
        waitACKImageViewNewFrame.origin = CGPointMake(chatMessageNewFrame.origin.x - 23, chatMessageNewFrame.origin.y);
    }else{
        chatMessageNewFrame.origin.x = teamChatMessageTextView.frame.origin.x;
    }
    chatMessageNewFrame.size.width = messageSize.width + PADDING*2;
    chatMessageNewFrame.origin.y = teamNameLabel.frame.size.height;
    chatMessageNewFrame.size.height = messageSize.height + PADDING*2;
    ourTeamWaitACKImageView.frame = waitACKImageViewNewFrame;
    teamChatMessageTextView.frame = chatMessageNewFrame;

    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake([[cellImageOriginArray objectAtIndex:cellArrayIndex] floatValue], 2, 36, 36)];
    [theImageView setImage:[ViewUtil circleMaskImageWithImage:[teamImageArray objectAtIndex:cellArrayIndex]]];
    [cell.contentView addSubview:theImageView];
    teamNameLabel.text = [NSString stringWithFormat:@"%@ 팀", theChatMessage.teamName];
    teamChatMessageTextView.text = theChatMessage.message;
    
    return cell;
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = [[chatDataController objectInMasterDataAtIndex:indexPath.row] message];
    CGSize size = [text sizeWithFont:UIFontHelveticaWithSize(14) constrainedToSize:CHAT_MESSAGE_CONSTRAINT lineBreakMode:NSLineBreakByCharWrapping];
    CGFloat textViewHeight = size.height + PADDING*2;
    
    CGFloat msgRowHeight = 15 + textViewHeight + 4;
    sumRowHeight += msgRowHeight;
    
    return msgRowHeight;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    if (sumRowHeight < self.view.frame.size.height) {
//        return self.view.frame.size.height - sumRowHeight;
//    }else return 0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - IBAction
- (IBAction)chattingMessageSendButtonTapped:(id)sender
{
    if (self.chattingMessageTextField.text != nil) {
        ChatMessage *sendMessage = [[ChatMessage alloc] initSendMessageWithMessage:self.chattingMessageTextField.text messageId:NACKedChatNum++ matchId:self.matchId teamHint:self.teamHint];
        [checkingChatACKDataController addChatMessageWithData:sendMessage];
        [self.chattingTableView reloadData];
        [self sendChattingMessageWithChatMessage:sendMessage];
        
        [self.chattingMessageTextField setText:nil];
    }
}

- (void)sendChattingMessageWithChatMessage:(ChatMessage *)chatMessage
{
    IMRequest *request = [[IMRequest alloc] init];
    
    [request setWithChatMessage:chatMessage];
    
    NSData *jsonBody = [[[SBJsonWriter alloc] init] dataWithObject:[request getInfoDictionary]];
    NSData *flushData = [[NSData alloc] initWithData:[@"\n" dataUsingEncoding:NSASCIIStringEncoding]];
    NSMutableData *messageBody = [NSMutableData dataWithData:jsonBody];
    [messageBody appendData:flushData];
    
    [outputStream write:[messageBody bytes] maxLength:[messageBody length]];
}

#pragma mark - NSStream Delegate
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent
{
    NSString *io;
    
    if (theStream == inputStream) {
        io = @">>";
    }else io = @"<<";
    
    NSString *event;
    switch (streamEvent) {
        case NSStreamEventNone:{
            event = @"NSStreamEventNone";
            break;
        }
        case NSStreamEventOpenCompleted:{
            event = @"NSStreamEventOpenCompleted";
            break;
        }
        case NSStreamEventHasBytesAvailable:{
            event = @"NSStreamEventHasBytesAvailable";
            if (theStream == inputStream) {
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    
                    if (len > 0) {
                        NSData *output = [NSData dataWithBytes:buffer length:len];
                        
                        if (output != nil) {
                            [self receiveMessage:output];
                        }
                    }
                }
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable:{
            event = @"NSStreamEventHasSpaceAvailable";
            break;
        }
        case NSStreamEventErrorOccurred:{
            event = @"NSStreamEventErrorOccurred";
            break;
        }
        case NSStreamEventEndEncountered:{
            event = @"NSStreamEventEndEncountered";
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        }
        default:
            event = @"** Unknown";
            break;
    }
}

- (void)receiveMessage:(NSData *)data
{
    NSError *error;
    NSDictionary *receiveDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    ChatMessage *theReceivedMessage = [[ChatMessage alloc] initWithData:receiveDict];
    NSLog(@"RECEIVED MESSAGE : %@", receiveDict);
    
    // ACK for my chatting message
    if (theReceivedMessage.ACK) {
        [chatDataController addChatMessageWithData:[checkingChatACKDataController objectInMasterDataWithMessageId:theReceivedMessage.messageId]];
        [checkingChatACKDataController removeChatMessageWithMessageId:theReceivedMessage.messageId];
        
    // RECEIVE competitive team message
    }else{
        [chatDataController addChatMessageWithData:theReceivedMessage];
    }
    [self.chattingTableView reloadData];
    [self.chattingMessageTextField becomeFirstResponder];
}

@end
