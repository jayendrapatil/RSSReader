#import <UIKit/UIKit.h>


@interface DetailViewController : UIViewController {
	
	IBOutlet UIImageView *imageView ;
	IBOutlet UIWebView *webView ;
	IBOutlet UILabel *titleLabel ;
	IBOutlet UILabel *date ;
	NSMutableDictionary *story ;

}

@property (nonatomic, retain) IBOutlet UIWebView *webView ;
@property (nonatomic, retain) IBOutlet UIImageView *imageView ;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel ;
@property (nonatomic, retain) NSMutableDictionary *story ;
@property (nonatomic, retain) IBOutlet UILabel *date ;

+ (DetailViewController *) DetailViewControllerWithStory:(NSMutableDictionary *) storyItem;

@end
