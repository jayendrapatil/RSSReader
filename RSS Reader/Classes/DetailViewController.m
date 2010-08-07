#import "DetailViewController.h"


@implementation DetailViewController
@synthesize webView, link;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSString *urlString = [NSString stringWithFormat:[[stories objectAtIndex:indexPath.row] objectForKey:@"link"]];
//	NSString *encodedUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; 
//	[rssWebView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:encodedUrl]]];
//	rssWebView.scalesPageToFit = YES;
//	
//	
//	UIViewController *thisVC = [[UIViewController alloc] init];
//	thisVC.view = rssWebView;
//	thisVC.title = [[stories objectAtIndex:indexPath.row]
//					objectForKey:@"title"];
//	
//	[self.navigationController pushViewController:thisVC animated:YES];
//	
//	[rssWebView release];
//	[thisVC release];
//	
	
	NSString *encodedUrl = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *url = [NSURL URLWithString:encodedUrl];
	NSError *theNetworkError;
	NSString *response = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&theNetworkError];
	
	if (response != nil)
	{
		NSString *storyContent;
		NSString *wordstart = @"<div class=\"storyContent\" id=\"storyContent\">";
		NSScanner *scanner = [NSScanner scannerWithString:response];
		BOOL found = FALSE;
		while (! [scanner isAtEnd]) {
			if ([scanner scanUpToString:wordstart intoString:NULL] && 
				[scanner scanString:wordstart intoString:NULL]	 &&
				[scanner scanUpToString:@"</div>" intoString:&storyContent]
				) {
				NSLog(@"Possible answer: %@", storyContent);
				found = TRUE;
			}
		}
		if (! found) {
			NSLog(@"No definition for %@ found",wordstart);
		}
		[webView loadHTMLString:storyContent baseURL:nil];
	} 
	
	webView.scalesPageToFit = YES ;
	
	//[webView loadRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:encodedUrl]]];
	[webView release];

}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return YES ;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[lblText release];
    [super dealloc];
}


@end
