#import <UIKit/UIKit.h>

@interface RootViewController : UITableViewController {
	
	IBOutlet UITableView * newsTable;
	UIActivityIndicatorView * activityIndicator;
	CGSize cellSize;
	NSXMLParser * rssParser;
	NSMutableArray * stories;
	NSMutableDictionary * item;
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink, *images;

}

@end
