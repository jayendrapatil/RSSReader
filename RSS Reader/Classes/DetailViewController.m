#import "DetailViewController.h"


@implementation DetailViewController
@synthesize webView, imageView, titleLabel, story, date;

+ (DetailViewController *) DetailViewControllerWithStory:(NSMutableDictionary *) storyItem {
	DetailViewController* retController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
	retController.story = storyItem ;
	return [retController autorelease];
}

- (void)viewDidLoad {
	
	NSData* imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[story objectForKey:@"image"]]];
	UIImage* image = [[UIImage alloc] initWithData:imageData];
	[imageView setImage:image];
	
	[titleLabel setText:[story objectForKey:@"title"]];
	[date setText:[story objectForKey:@"date"]];
	
	
	NSString *encodedUrl = [[story objectForKey:@"link"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
				NSLog(@"Story Content: %@", storyContent);
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
	[imageData release];
	[image release];

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
    [super dealloc];
}


@end
