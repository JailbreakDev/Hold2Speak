#import <CaptainHook/CaptainHook.h>

#define isiOS7 (kCFCoreFoundationVersionNumber >= 800.00)

@interface TPButton : UIButton
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
{
}

+ (id)notificationCenterForType:(id)arg1;
+ (id)defaultCenter;
- (BOOL)suspended;
- (void)setSuspended:(BOOL)arg1;
- (void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3;
- (void)postNotificationName:(id)arg1 object:(id)arg2;
- (void)postNotification:(id)arg1;
- (void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 deliverImmediately:(BOOL)arg4;
- (void)postNotificationName:(id)arg1 object:(id)arg2 userInfo:(id)arg3 options:(unsigned int)arg4;
- (void)removeObserver:(id)arg1 name:(id)arg2 object:(id)arg3;
- (id)addObserverForName:(id)arg1 object:(id)arg2 queue:(id)arg3 usingBlock:(id)arg4;
- (id)addObserverForName:(id)arg1 object:(id)arg2 suspensionBehavior:(unsigned int)arg3 queue:(id)arg4 usingBlock:(id)arg5;
- (void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4;
- (void)addObserver:(id)arg1 selector:(SEL)arg2 name:(id)arg3 object:(id)arg4 suspensionBehavior:(unsigned int)arg5;
- (id)init;

@end

@interface InCallController : UIViewController <UILongPressGestureRecognizerDelegate>
-(int)speakerButtonPosition;
-(void)sixSquareButtonClicked:(int)arg1;
-(void)viewDidAppear:(BOOL)arg1;
-(void)viewDidDisappear:(BOOL)arg1;
@end

@interface TPSuperBottomBar : UIView
@property (nonatomic,retain) TPButton * mainRightButton;
-(void)setMainRightButton:(TPButton *)rightButton;
-(void)buttonPressed:(id)btn;
-(void)setSlidingButton:(id)arg1;
-(void)slidingButton:(id)arg1 didSlideToProportion:(float)arg2;
@end

@interface TPBottomDoubleButtonBar
- (id)button2;
@end

@interface CallBarController
//+ (id)sharedCallBarControllerIfExists;
- (void)setRouteToSpeaker;
- (void)addGestureRecognizer:(id)arg1;
- (id)answerButton;
- (void)answerCall;
@end

void sendSpeakerNotification (BOOL isCallBar)
{
  NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [[NSDistributedNotificationCenter defaultCenter] postNotificationName:(isCallBar) ? @"Hold2ShakeUseSpeakerCallbarNotification" : @"Hold2ShakeUseSpeakerNotification" object:nil userInfo:dict deliverImmediately:YES];
  });
  [dict release];


}
%hook CallBarController
- (void)showCallBarWithCall:(struct __CTCall *)fp8 callType:(unsigned int)fp12 fromID:(id)fp16 conferenceID:(id)fp20
{
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(useSpeaker:) name:@"Hold2ShakeUseSpeakerCallbarNotification" object:nil];
    %orig;
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/"] stringByAppendingPathComponent:[NSString stringWithFormat: @"org.thebigboss.callbarprefs.plist"]];
    NSMutableDictionary* plistDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filePath] autorelease];
    BOOL usesButtons = [[plistDict objectForKey:@"showsButtons"]boolValue];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressReceived:)];
    longPress.minimumPressDuration = 1.0;
    if(usesButtons)[[self answerButton] addGestureRecognizer:longPress];
    //else
      //[CHIvar(self,_contentView,id)addGestureRecognizer:longPress];
    [longPress release];

}
- (void)viewDidHide

{
  [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"Hold2ShakeUseSpeakerCallbarNotification" object:nil];
  %orig;
}
%new
-(void)longPressReceived:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        sendSpeakerNotification(YES);
        [self answerCall];
        //[(UIButton*)sender.view sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
}
%new
- (void)useSpeaker:(NSNotification *)notification {
    BOOL wants = [[[notification userInfo] objectForKey:@"Speaker"] boolValue];
    if (wants)
      //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
          [self setRouteToSpeaker];
        //});
}
%end
//On iOS 6 InCallController viewDidAppear:
// is called after the call is answered.
%hook PhoneRootViewController
-(void)viewDidAppear:(BOOL)arg1 {
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(useSpeaker:) name:@"Hold2ShakeUseSpeakerNotification" object:nil];
    %orig(arg1);

}
-(void)viewDidDisappear:(BOOL)arg1 {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"Hold2ShakeUseSpeakerNotification" object:nil];
    %orig(arg1);
}
%new
%new
- (void)useSpeaker:(NSNotification *)notification {
    BOOL wants = [[[notification userInfo] objectForKey:@"Speaker"] boolValue];
    if (wants)
    //on iOS6 the speaker seems to
    //enable and subsequently, disable
		  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
          [CHIvar(self,_inCallViewController,id) sixSquareButtonClicked: (isiOS7) ? [CHIvar(self,_inCallViewController,id) speakerButtonPosition] : 2];
		    });
    //this delay seems to fix that
}
%end
%hook TPBottomDoubleButtonBar
- (id)initForIncomingCallWithFrame:(struct CGRect)arg1
{
  self = %orig;
  if(self)
  {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressReceived:)];
    longPress.minimumPressDuration = 1.0;
    [[self button2] addGestureRecognizer:longPress];
    [longPress release];
  }
  return self;
}

%new
-(void)longPressReceived:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        sendSpeakerNotification(NO);
        [(TPButton*)sender.view sendActionsForControlEvents: UIControlEventTouchUpInside];
    }
}
%end
%hook TPSuperBottomBar

-(void)setSlidingButton:(UIView *)slidingButton {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressReceived:)];
    longPress.minimumPressDuration = 1.0;
    longPress.cancelsTouchesInView = YES;
    [slidingButton addGestureRecognizer:longPress];
    [longPress release];
    %orig(slidingButton);
}

-(void)setMainRightButton:(TPButton *)rightButton {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressReceived:)];
    longPress.minimumPressDuration = 1.0;
    [rightButton addGestureRecognizer:longPress];
    [longPress release];
    %orig(rightButton);
}

%new

-(void)longPressReceived:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        sendSpeakerNotification(NO);
        [self buttonPressed:(TPButton *)sender.view];
        [self slidingButton:sender.view didSlideToProportion:0.0f];
    }
}

%end
