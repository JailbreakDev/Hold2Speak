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

@interface InCallController : UIViewController
-(int)speakerButtonPosition;
-(void)sixSquareButtonClicked:(int)arg1;
-(void)viewDidAppear:(BOOL)arg1;
-(void)viewDidDisappear:(BOOL)arg1;
@end

@interface TPButton : UIButton
@end

@interface TPSuperBottomBar : UIView 
@property (nonatomic,retain) TPButton * mainRightButton;
-(void)setMainRightButton:(TPButton *)rightButton;
-(void)buttonPressed:(id)btn;
-(void)setSlidingButton:(id)arg1;
-(void)slidingButton:(id)arg1 didSlideToProportion:(float)arg2;
@end

%hook InCallController

-(void)viewDidAppear:(BOOL)arg1 {
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(useSpeaker:) name:@"Hold2ShakeUseSpeakerNotification" object:nil];
    %orig(arg1);
}

-(void)viewDidDisappear:(BOOL)arg1 {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"Hold2ShakeUseSpeakerNotification" object:nil];
    %orig(arg1);
}

%new
- (void)useSpeaker:(NSNotification *)notification {
    BOOL wants = [[[notification userInfo] objectForKey:@"Speaker"] boolValue];
    if (wants) {
        [self sixSquareButtonClicked:[self speakerButtonPosition]];
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
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"Hold2ShakeUseSpeakerNotification" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
        [self buttonPressed:(TPButton *)sender.view];
        [self slidingButton:sender.view didSlideToProportion:0.0f];
    }
}

%end