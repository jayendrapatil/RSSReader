#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
	
	IBOutlet UIWebView *webView ;
	IBOutlet UILabel *lblText;
	NSString *link ;

}

@property (nonatomic, retain) IBOutlet UIWebView *webView ;
@property (nonatomic, retain) NSString *link ;

@end
