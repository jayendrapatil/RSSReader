//
//  DetailViewController.m
//  RSS Reader
//
//  Created by Basav Nagur on 7/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@implementation DetailViewController
@synthesize webView, item, link ;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

+ (DetailViewController*) detailViewControllerWithItem:(NSString*) newlink {
	DetailViewController* retController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
	//[retController setItem:selectedItem];
	[retController setLink:newlink];
	//NSLog([selectedItem objectForKey: @"link"]);

	return [retController autorelease];
} 


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	//NSString *urlAddress = @"http://www.mckinseyquarterly.com/Economic_Studies/Country_Reports/Indias_urbanization_A_closer_look_2640?gp=1";
	//NSString *urlAddress = @"http://rss.mckinseyquarterly.com/l?s=100003s2f3fmpgm5lb0&r=unknown&he=687474702533412532462532467777772e6d636b696e736579717561727465726c792e636f6d2532466c696e6b732532463339383630&i=6c633a32363431";

	//NSLog([item objectForKey:@"link"]);
	//NSString *urlAddress = (NSString *) [item objectForKey:@"link"];
	NSLog(link);
	NSURL *url = [NSURL URLWithString:link];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	[item release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
