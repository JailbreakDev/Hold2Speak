
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

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

#import <UIKit/UIKit.h>

@interface TPSlidingButton : UIView

@end

@interface PHAudioCallControlsView : UIView{}
- (void)buttonTapped:(id)arg1;
- (id)buttonForControlType:(unsigned long long)arg1;
@end

@interface PHAudioCallControlsViewController : UIViewController {
    PHAudioCallControlsView *_controlsView;
}
- (void)viewDidAppear:(BOOL)arg1;
- (BOOL)controlTypeIsEnabled:(unsigned long long)arg1;
- (BOOL)controlTypeIsSelected:(unsigned long long)arg1;
@end

@interface TPButton : UIButton
@end
//#import <AddressBookUI/AddressBookUI.h>

@interface TPSuperBottomBar : UIView {
    
}
@property (nonatomic,retain) TPButton * mainRightButton;
@property(retain, nonatomic) TPSlidingButton * slidingButton;
-(void)setMainRightButton:(TPButton *)rightButton;
-(void)buttonPressed:(id)btn;
-(void)setSlidingButton:(TPSlidingButton *)arg1;
-(void)slidingButton:(id)arg1 didSlideToProportion:(float)arg2;
- (void)slidingButtonDidFinishSlide;
- (void)slidingButtonWillFinishSlide;
-(id)initWithFrame:(struct CGRect)arg1;
@end

@interface InCallController : UIViewController {
}
-(void)viewDidAppear:(BOOL)arg1;
-(void)sixSquareButtonClicked:(int)arg1;
-(int)speakerButtonPosition;
-(void)viewDidDisappear:(BOOL)arg1;
@end

@interface DialerController : UIViewController{}
-(void)_callButtonPressed:(id)arg1;
-(void)viewWillAppear:(BOOL)arg1;
@property (readonly) id dialerView;
@end

@interface PHRecentsViewController: UIViewController {}
-(id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2;
@end

@interface PHFavoritesViewController : UIViewController {}
-(id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 ;
-(void)tableView:(id)arg1 didSelectRowAtIndexPath:(id)arg2 ;
-(int)selectedIndex;
@end

@interface CKTranscriptRecipientsController : UITableViewController <UIActionSheetDelegate, UIAlertViewDelegate, UITextViewDelegate> {}
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2;
- (void)phoneCallAction:(id)arg1;
- (void)_startCallWithAddress:(id)arg1 entity:(id)arg2;
- (void)_startCommunicationForEntity:(id)arg1;
- (void)_startFacetimeCommunicationForEntity:(id)arg1 audioOnly:(bool)arg2;
@end


%hook TPSuperBottomBar

-(void)setSlidingButton:(TPSlidingButton *)arg1 {
    %orig(arg1);
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(gestHold:)];
    tapper.numberOfTapsRequired = 2;
    [arg1 addGestureRecognizer:tapper];
    UILongPressGestureRecognizer *hold2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestHold:)];
    hold2.minimumPressDuration = 1.0;
    hold2.cancelsTouchesInView = YES;
    [arg1 addGestureRecognizer:hold2];
    [hold2 release];
}

-(void)setMainRightButton:(TPButton *)rightButton {
    UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestHold:)];
    hold.minimumPressDuration = 1.0;
    [rightButton addGestureRecognizer:hold];
    [hold release];
    %orig(rightButton);
}

%new
-(void)gestHold:(id)arg1 {
    UIGestureRecognizer *sender = (UIGestureRecognizer *)arg1;
    if (sender.state == UIGestureRecognizerStateBegan || [arg1 isKindOfClass:[UITapGestureRecognizer class]]) {
        [self buttonPressed:(TPButton *)sender.view];
        [self slidingButton:sender.view didSlideToProportion:0.0f];
        if ([self respondsToSelector:@selector(slidingButtonWillFinishSlide)]) {
            [self slidingButtonWillFinishSlide];
        }
        if ([self respondsToSelector:@selector(slidingButtonDidFinishSlide)]) {
            [self slidingButtonDidFinishSlide];
        }
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
    }
}

%end
/*
%hook PHAudioCallControlsView
- (void)buttonTapped:(id)arg1 {
    //NSLog(@"The button tapped is: %@", arg1);
    %orig(arg1);
}
- (id)buttonForControlType:(unsigned long long)arg1 {
    //NSLog(@"The button shown is: %llul", arg1);
    return %orig(arg1);
}
%end
*/
%hook PHAudioCallControlsViewController
//int times = 0;
//PHAudioCallControlsView *_controlsView;
- (void)viewDidAppear:(BOOL)arg1 {
    %orig(arg1);
    //NSLog(@"The view is: %@", self.view);
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(useSpeaker:) name:@"SpringboardCallsSpeaker" object:nil];
}
-(void)viewDidDisappear:(BOOL)arg1 {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"SpringboardCallsSpeaker" object:nil];
    %orig(arg1);
}

%new
- (void)useSpeaker:(NSNotification *)notification {
    //NSLog(@"HI!");
    BOOL wants = [[[notification userInfo] objectForKey:@"Speaker"] boolValue];
    if (wants) {
        if ([self controlTypeIsSelected:2] == FALSE) {
            PHAudioCallControlsView *callView = (PHAudioCallControlsView *)self.view;
            [callView buttonTapped: [callView buttonForControlType:2]];
        }
    }
}
%end

%hook InCallController

-(void)viewDidAppear:(BOOL)arg1 {
    %orig(arg1);
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(useSpeaker:) name:@"SpringboardCallsSpeaker" object:nil];
}

-(void)viewDidDisappear:(BOOL)arg1 {
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"SpringboardCallsSpeaker" object:nil];
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

%hook DialerController

-(void)_callButtonPressed:(id)arg1 {
    %orig(arg1);
}


-(void)viewWillAppear:(BOOL)arg1 {
    TPButton *callB = [self.dialerView performSelector:@selector(callButton)];
    UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestHold:)];
    hold.minimumPressDuration = 1.0;
    [callB addGestureRecognizer:hold];
    [hold release];
    %orig(arg1);
}

%new
-(void)gestHold:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self _callButtonPressed:(TPButton *)sender.view];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
    }
}

%end

%hook PHRecentsViewController

-(id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
    UITableViewCell *cell = %orig(arg1,arg2);
    UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestHold:)];
    hold.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:hold];
    [hold release];
    return cell;
}

%new
-(void)gestHold:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        id view = [sender.view superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        UITableView *tableView = (UITableView *)view;
        UITableViewCell *cell = (UITableViewCell *)sender.view;
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
    }
}

%end

%hook PHFavoritesViewController
NSIndexPath *indexPath;
BOOL testy=FALSE;

-(id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
    UITableViewCell *cell = %orig(arg1,arg2);
    UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHold:)];
    hold.minimumPressDuration = 1.0;
    [cell addGestureRecognizer:hold];
    [hold release];
    return cell;
}


-(int)selectedIndex {
    if (testy) {
        int returning = (int)indexPath.row;
        testy=FALSE;
        return returning;
    }
    else {
        return %orig;
    }
}

%new
-(void)gestureHold:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        id view = [sender.view superview];
        while (view && [view isKindOfClass:[UITableView class]] == NO) {
            view = [view superview];
        }
        UITableView *tableView = (UITableView *)view;
        UITableViewCell *cell = (UITableViewCell *)sender.view;
        indexPath = [tableView indexPathForCell:cell];
        testy=TRUE;
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        	[[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
    }
}

%end

%hook CKTranscriptRecipientsController
BOOL shouldSpeak=FALSE;

- (void)_startCallWithAddress:(id)arg1 entity:(id)arg2 {
    if (shouldSpeak) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
        shouldSpeak = FALSE;
    }
    %orig(arg1, arg2);
}

- (void)_startCommunicationForEntity:(id)arg1 {
    if (shouldSpeak) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
        shouldSpeak = FALSE;
    }
    %orig(arg1);
}

- (void)_startFacetimeCommunicationForEntity:(id)arg1 audioOnly:(BOOL)arg2 {
    if (arg2) {
        if (shouldSpeak) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
            });
            [dict release];
            shouldSpeak = FALSE;
        }
    }
    %orig(arg1,arg2);
}
/*
- (void)viewWillAppear:(BOOL)arg1 {
    %orig(arg1);
    shouldSpeak = FALSE;
}
 
-(void)viewWillDisappear:(BOOL)arg1 {
    %orig(arg1);
    NSLog(@"I am being called");
    BOOL existence = NSClassFromString(@"NSDistributedNotificationCenter") != nil;
    NSLog(@"The NC exists: %s", existence?"True":"False");
    if (shouldSpeak) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
        shouldSpeak = FALSE;
    }
}
*/
- (id)tableView:(id)arg1 cellForRowAtIndexPath:(id)arg2 {
    UITableViewCell *original = %orig(arg1,arg2);
    NSIndexPath *idPath = (NSIndexPath *)arg2;
    if (idPath.section == 0) {
        NSArray *subviews = [[[original subviews] objectAtIndex:0] subviews];
        UIButton *phoneButton;
        for (id sview in subviews) {
            if ([sview isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)sview;
                UIImage *theIMG = btn.currentImage;
                UIImage *abImage = [UIImage performSelector:@selector(abImageNamed:) withObject:@"card-transport-phone"];
                NSData *data1 = UIImagePNGRepresentation(theIMG);
                NSData *data2 = UIImagePNGRepresentation(abImage);
                BOOL equality = [data1 isEqual:data2];
                if (equality) {
                    phoneButton = btn;
                    UILongPressGestureRecognizer *hold = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestHold:)];
                    hold.minimumPressDuration = 1.0;
                    hold.cancelsTouchesInView = YES;
                    [phoneButton addGestureRecognizer:hold];
                    [hold release];
                }
            }
        }
    }
    
    return original;
}

- (void)actionSheet:(UIActionSheet *)arg1 clickedButtonAtIndex:(NSInteger)arg2 {
    if (shouldSpeak) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithBool:TRUE], @"Speaker", nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"SpringboardCallsSpeaker" object:nil userInfo:dict deliverImmediately:YES];
        });
        [dict release];
        shouldSpeak = FALSE;
    }
    %orig(arg1, arg2);
}

%new
-(void)gestHold:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        shouldSpeak = TRUE;
        [self phoneCallAction:sender.view];
    }
}

%end