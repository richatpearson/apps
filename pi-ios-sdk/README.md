# Pearson Identity Client iOS SDK Framework

##Overview
The Pearson Identity Client iOS SDK framework (Pi-ios-client) assists in accessing the services provided by the Pearson Identity API. 

The Pi-ios-client provides the means of obtaining OAuth 2 tokens and managing the secure storage of those tokens as well as credentials.

##Specifications
* supports iOS 6 +
* supports ARC and non-ARC applications

##Getting Started

Simply add the **Pi-ios-client.framework** to your project.

Make sure that "Other Linker Flags" in "Build Settings" has the following settings:

    -ObjC 

This flag will tell the  linker to link all Objective-C classes and categories from static libraries into your application even if the linker can't tell if they are used.

Pi-ios-client SDK requires the Security.framework for storing data in Keychain Services. 

##Install the Pearson Identity Client iOS SDK
The easiest way to incorporate the SDK into your project is to use CocoaPods. For information on setting up CocoaPods on your system, visit http://cocoapods.org/.

###Adding the GRID Mobile CocoaPods specifications repository

```
pod repo add gridmobile-cocoapods ssh://git@devops-tools.pearson.com/mp/gridmobile-cocoapods.git
```

###Including the Pi-ios-client framework
Create a PodFile for your project that specifies the pi-ios-sdk dependency. For example:

```
platform :ios, "7.1"

target "PiClientStaging" do
    pod 'pi-ios-sdk', '1.1.0'
end
```

Then install the dependencies:

```
pod install
```

Open the **_.xcworkspace_** file that manages the new dependencies for your project and you can begin to incorporate the sdk into your code.

###Requirements
1. A client Id, client secret, and redirectUrl are required to connect with Pi Services. These can be obtained by contacting the Pi Team and creating a Client Account through them. Their documentation on Confluence contains the information for doing this [https://hub.pearson.com/confluence/display/IAM/Pi+API+Documentation].

###Usage
Please refer to the **PiClient** sample application  (in the repository's samples folder) for an example of using the **PiClient** to retrieve an authorization token and unique user id.

####The PiClient Instance
After importing the PiClient framework into your application, the next thing to do is create an instance of the PiClient using the client id, client secret, and redirectUrl.

```
self.piClient = [[PGMPiClient alloc] initWithClientId:self.clientId 
                                         clientSecret:self.clientSecret
                                          redirectUrl:self.redirectUrl];
```

It is often convenient to do this in the application delegate so that the instance is easily accessible to all other classes in your application.

**Note: The current version of Pi-ios-client framework does not support multiple users within a single PiClient instance. It is recommended that you create a separate instance of PiClient for each user and manage those instances in the same fashion that you currently manage multiple users.**

#####The Environment
The next step is to set the environment for the PiClient. Pi currently offers two environments, Staging and Production, and you can set them accordingly (Staging Environment is set by Default: 

```
Staging: PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
Production: PGMPiEnvironment *environment = [PGMPiEnvironment productionEnvironment];
```

This assures that the paths used in the requests are correct. Note that instantiating the environment using `[PGMPiEnvironemnt new]` or `[[PGMPiEnvironment alloc] init]` is **NOT** allowed.

If the need arises, you can also customize properties in the environment.

```
PGMPiEnvironment *customEnvironment = [PGMPiEnvironment stagingEnvironment];
customEnvironment setBasePiURL: @"https://my-custom-pi-base-url.com/";
customEnvironment setBaseEscrowURL: @"https://my-custom-pi-escrow-url/";
customEnvironment setLoginSuccessURL: @"https://my-custom-pi-success-url.com/pi-login-success";
```

Setting the environment in the piClient is simple.

```
[self.piClient setEnvironment: environment];
```

#####Secure Storage
PiClient stores the tokens it receives from the the Pi Token Service within Keychain services. By default, it also securely stores the user's credentials (username/password).

If you do not wish to store the username and password in the Keychain, you can turn this default behavior off.

```
self.piClient.secureStoreCredentials = NO;
```

If you wish to save the token and/or credential data to a keychain access group, you can set that this way:

```
[self.piClient setKeychainAccessGroup:self.accessGroup];
```

The default setting for keychain accessibility is kSecAttrAccessibleWhenUnlocked (The data in the keychain item can be accessed only while the device is unlocked by the user) but you can override that:

```
[self.piClient setKeychainAccessibility: kSecAttrAccessibleAlways];
```

#####Login Options
For the current release, there are no additional options for accessing Pi Services when logging in. The framework will only return tokens and a user Id.

####Login-related Requests
The login-related requests that you can make through Pi-ios-client framework are:

1. PiLoginRequest - Login requests are used for submittting username and password to retrieve fresh set of access token/refresh token
2. PiTokenRefreshRequest - Forces a submit of the refresh token to get a new set of access token/refresh token

####Responses
For every request made to the PiClient, a PGMPiResponse response object is returned. Each response contains a piResponseId (session based...the id is basically a counter) for the piRequestType. The userId and current accessToken are also returned within the response object.

If there is an error during the request, it will be returned in the error property of the response object.

If the request was successful, any returned data will be stored in the response object's dictionary as a value whose key is the operation type that fetched the data.

The following table shows the request type and the associated operations:

<table>
<tr><th>PGMPiRequestType</th><th>PGMPiOperationType</th><th>Returned Object</th></tr>
<tr><td>PiLoginRequest</td><td>PiTokenOp</td><td>PGMPiToken</td></tr>
<tr><td></td><td>PiUserIdOp</td><td>PGMPiCredentials</td></tr>
<tr><td>PiTokenRefreshRequest</td><td>PiTokenRefreshOp</td><td>PGMPiToken</td></tr>
</table>

 The following is an example of how you would retrieve data from the response object:
 
    PGMPiToken *tokenObject = [response getObjectForOperationType:PiTokenOp];
    PGMPiCredentials *creds = [response getObjectForOperationType:PiUserIdOp];

The requestStatus property of the PGMPiResponse object will indicate one of 3 possible statuses for the response:

1. PiRequestPending: Request is submitted to Pi Server and results are pending.
2. PiRequestSuccess: Request has been submitted and data was successfully returned.
3. PiRequestFailure: Request was attempted but there was a failure somewhere along the way.
    
The PiClient can respond in one of three ways depending on how the developer chooses.

1. OnComplete Block: If a request is made with a completion handler, the client will respond by executing the block.
2. Delegate: If no completion block exists, the PiClient will try to respond through the PGMPiClientDelegate delegateResponse: method.
3. Dispatch a Notification: the PiClient will dispatch a notification with a name reflecting the type of request and the response object attached.
    * PGMPiLoginRequest
    * PGMPiTokenRefreshRequest
    
####Logging In
The following example shows how you would login in to Pi with a completion block using the default login options.

    [self.piClient loginWithUsername:username
                            password:password
                             options:nil
                          onComplete:loginCompletionHandler];
                          
####Refreshing the Token
The following is an example of how you would force a refresh of the access tokens with a simple completion Handler block.

     PiRequestComplete tokenRefreshCompletionHandler = ^(PGMPiResponse *response)
    {
        if(response.error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TokenRefreshError" object:response];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TokenRefreshed" object:response];
            });
        }
    };
    [self.piClient refreshAccessTokenAndOnComplete:tokenRefreshCompletionHandler];

#### Checking the token
You can validate the  current token stored in the PiClient with or without the user Id.

    PGMPiResponse *response = [self.piClient validAccessTokenWithUserId:self.piCredentials.userId 
                                                             onComplete:validTokenCompletionHandler];

or

    PGMPiResponse *response = [self.piClient validAccessTokenAndOnComplete:validTokenCompletionHandler];
    
If the current access token is valid (based on the current clock setting on the device in relation to the expiresIn value sent from Pi), it is returned in the response. If not, a token refresh will automatically be generated. (Response object will be of type PiTokenRefreshRequest.)

#### User Consent Flow
When attempting to log in through Pi for the first time, the user will be required to consent to certain policies (e.g.: terms of use, privacy, etc). The PiClient will return an error of type `PGMPiNoConsentError` (int value of 7) in the login request's response object. The response will also contain an array of consent policy objects (`PGMPiConsentPolicy`) that will need to be reviewed and consented to by the user. Here is an example of how to pull this data from the response object. 

    NSArray *consentPolicies = (NSArray*)[response getObjectForOperationType:PiTokenOp];

Each consent policy object contains a url that points to the text for that policy (`consentPageUrl`). There are also two boolean values to indicate if the user has been shown the policy (`isReviewed`) and if the user consented to the policy (`isConsented`). 

These policies should be shown to user one by one for review and consent. After all policies have been cycled through and review and consent have been properly indicated, the array of consent policy objects can be returned through the PiClient.

    [self.piClient submitConsentPolicies:consentPolicies
                     withCurrentUsername:self.currentUsername
                             andPassword:self.currentPassword
                              onComplete:consentFlowCompletionHandler];

Currently, in order to finish the login process, all policies must be reviewed and consented to. If this is the case, then after the SDK successfully posts the consents to Pi, the login process will continue as normal. Please see the sample app for a detailed working example of this flow.

#### Logging out
You can log the current user out with PiClient. Logging the user out will remove any tokens and credentials stored within PiClient and the keychain for this session.

    [self.piClient logout];
    
You can also check if the current user is logged out:

    [self.piClient isLoggedOut];

####Forgot Password
In the event that a user has forgotten their password, a reset request can be submitted through the Pi Client. As with other requests, it can be done with or without a completion block.

    [self.piClient forgotPasswordForUsername:userName];
    
or
    
    [self.piClient forgotPasswordForUsername:userName
                                  onComplete:forgotPasswordCompletionHandler];  

If a completion block is not provided, the name of the notification broadcasted upon completion of this task is `PGMPiForgotPasswordRequest`.

If the Forgot Password request submission was a success, an html string is returned from the server.

    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
			<title>Password Retrieval</title>
		</head>
		<body>
			<b>You have been sent an email to reset your password</b>
		</body>
	</html>
 
It is possible that too many password reset requests can be submitted by a user (limit of 10). In the event of such an occurrence, a dictionary object is returned in the response.

    {
    	"status":"error",
    	"message":"Too many tickets for resource ForgotPassword and ownder ffffffff53f82770e4b0ed5d911a3304",
    	"code":"404-NOT_FOUND"
    }
    
The typo "ownder" is known by the Pi team and will be corrected soon. In any event, a more appropriate response should be conveyed to the user.

Should you experience this error while developing your application, you can reset it easily enough by POSTing the following body text to the escrow service where ownerId is the identity id.

    URL: https://escrow.stg-openclass.com/escrow/regenerate
    
    raw body text: {"resource":"ForgotPassword","ownerId":"################################"} 

####Forgot Username
Forgotten Username requests can be submitted through the Pi Client in a similar fashion as Forgotten Password requests using the user's email address.

     [self.piClient forgotUsernameForEmail:email];
     
or with a completion block:

    [self.piClient forgotUsernameForEmail:email
                               onComplete:forgotUsernameCompletionHandler];

If a completion block is not provided, the name of the notification broadcasted upon completion of this task is `PGMPiForgotUsernameRequest`.

A successful response for this request returns an html string.

    "
	\n<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
	\n<html>
	\n<heapec.source                = { :git => 'ssh://git@devops-tools.pearson.com/mp/pi-ios-sdk.git', :tag => 'tag/1.2.0' }>
	\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\">
	\n<title>ForgotUsername - PIAPI Sample Forgot Username Retrieval</title>
	\n</head>
	\n<body>
	\n
	\n<b>Username has been sent to primary email : barry.tomack@pearson.com</b>
	\n</body>
	\n</html>
	"

An unsuccessful response will return the following:

    {
        code = "404-NOT_FOUND";
        message = "No user found for email address : bademail.address@pearson.com";
        status = error;
    };
    
## Report Issues
Frequently asked questions and support from the GRID Mobile community can be found on the [Pearson Developers Network community support pages](http://pdn.pearson.com/community). Browse the forums for assistance or submit a new question.
