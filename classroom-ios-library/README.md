#GRID Mobile Classroom iOS Library

##Overview
The GRID Mobile Classroom iOS Library (classroom-ios library) assists with obtaining class-related information, such as list of courses student is registered for or course content.

##System Requirements

* iOS 7.1 or newer
* Compatible with both ARC and non-ARC applications.

##Getting Started
The following frameworks are required:

Simply add the **classroom-ios.framework** to your project.

Make sure that "Other Linker Flags" in "Build Settings" has the following settings:

    -ObjC


##Install classroom ios framework
The easiest way to incorporate the SDK into your project is to use CocoaPods. For information on setting up CocoaPods on your system, visit http://cocoapods.org/.

###Adding the GRID Mobile CocoaPods specifications repository

```
pod repo add gridmobile-cocoapods ssh://git@devops-tools.pearson.com/mp/gridmobile-cocoapods.git
```

###Including the classroom-ios framework
Create a PodFile for your project that specifies the classroom-ios-library, core, and pi dependencies. For example:

```
platform :ios, "7.1"

target "CourseListClient" do
  pod 'core-ios-sdk', '1.2.0'
  pod 'pi-ios-sdk', '1.1.0'
  pod 'classroom-ios-library', '0.1.0-SNAPSHOT'
end

target "CourseListClientTests" do
  pod 'core-ios-sdk', '1.2.0'
  pod 'pi-ios-sdk', '1.1.0'
  pod 'classroom-ios-library', '0.1.0-SNAPSHOT'
end
```

Then install the dependencies:

```
pod install
```

Open the **_.xcworkspace_** file that manages the new dependencies for your project and you can begin to incorporate the sdk into your code.


###Implementation

First you need to set up the PGMClssRequestManager object

In your app delegate you could have:

```
PGMClssRequestManager *clssRequestManager = [[PGMClssRequestManager alloc] initWithFetchPolicy:PGMClssNetworkFirst];
```

This instance of request manager is initialized to perform network requests first before caching any data.
Then you need to indicate which environment you need. The following code snippet configures staging environment:

```
PGMClssEnvironment *env = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssStaging];

[clssRequestManager setEnvironment:env];
```

The request manager is now ready to run requests.

##Supported Features

###Course List

The data you need to obtain before making this call is:
 * user identity Id
 * user access token

You may want to see the README.md for Pi ios client to get more information on how to make those calls.

Here is an example of how to use request manager to get course list:

```
[clssRequestManager getCourseListForUser:self.userIdentity
                               withToken:self.accessToken
                              onComplete:^(PGMClssCourseListResponse *response) {
        if (response.error)
        {
            NSLog(@"Error getting course list for user");
        }
        else
        {
            [self.courseListItems addObjectsFromArray:response.courseListArray];
        }
    }];
``` 
The local variables self.userIdentity and self.accessToken were provided values after calling Pi to login.

###Course Structure


###Assignments

Assignments can be retrieved for a course. Assignments are represented as PGMClssAssignment.

Assignments are retrieved by first obtaining a PGMClssCourseListItem for the course or courses you are interested in, then sending another call to retrieve an assignment or assignments for the desired courses. Assignments are retrieved by section ID. Conceptually, an assignment has assignment activities. For example, an assignment may be "Complete Module 1", and have activities "Read Chapter 1", "Write Chapter 1 Summary", "Complete Chapter 1 Exercises". Note than an assignment does not have a due date but an assignment activity does have a due date.

Data you need to obtain before making calls for assignments:
 * user access token
 * PGMClssCourseListItem containing the section ID to retrieve assignments for

Here is an example of how to use request manager to get an assignment:

```
[clssRequestManager getAssignmentsForCourse:courseListItem
                                   andToken:self.accessToken
                                 onComplete:^(PGMClssAssignmentResponse *response) {
        if (response.error)
        {
            NSLog(@"Error getting assignments for course");
        }
        else
        {
            [self.assignments addObjectsFromArray:response.assignmentsArray];
        }
    }];
```

Here is an example of how to use request manager to get assignments across courses:

```
[clssRequestManager getAssignmentsForCourses:courseListItems
                                    andToken:(NSString *)token
                                  onComplete:^(PGMClssAssignmentResponse *response) {
        if (response.error)
        {
            NSLog(@"Error getting assignments for course");
        }
        else
        {
            [self.assignments addObjectsFromArray:response.assignmentsArray];
        }
    }];
```

Here is an example of how to sort assignment activities:

```
NSArray *sortedAssignmentActivities = [PGMClssAssignmentSorting sortAssignmentActivities:self.assignments
                                                                                      by:PGMClssDueDate
                                                                               ascending:NO];
```

##Getting Help
Frequently asked questions and support from the GRID Mobile community can be found on the [Pearson Developers Network community support pages](http://pdn.pearson.com/community). Browse the forums for assistance or submit a new question.
