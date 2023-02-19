
# Minigram - Lite SNS App

Minigram social network app is a small-scale platform for users to connect with friends and family, share updates, photos, and text, and engage in social interactions such as liking and posting. It typically includes features like a user profile, newsfeed and view their posts.


![Logo](https://i.ibb.co/SyPZXQz/output-onlinepngtools-1-1.png)


## Get Started
This is instructions on setting up the Minigram project locally. Please follow the steps to run the app in your "Xcode".
## Installation

To get started and run the app, you need to follow these simple steps:

1. Clone the repository using the git clone command, followed by the repository's URL. 
2. Navigate to the directory where you want to clone the repository by using the cd command
3. Next, you need to install the dependencies using CocoaPods

    ```bash
    pod install
    ```
4. Once the installation is complete, open the Xcode project
5. Finally, you can run your app in Xcode by selecting a simulator or a physical device and clicking the "Run" button.
    
## Features

- **Sign Up, Sign In, and Sign Out:** Users can create a new account, sign in with their existing credentials, and sign out when they are done.
- **Create Posts:** Users can create posts by adding text, images, or both, with the ability to apply filters and crop images before posting.
- **Feed:** Users can view the posts of other users in their feed, sorted by time posted.
- **Delete Posts:** Users can delete their own posts at any time after they have been posted.
- **Like Posts:** Users can like posts by clicking on a heart icon. The number of likes is displayed on each post.
- **Profile:** Users can change their profile information or upload a new profile picture at any time, and view their own posts and liked posts in their profile section.
- **Timestamps:** All posts display a "time ago" timestamp, indicating how long ago the post was created.


## Features Demo
Check out Minigram app in action below

### Login and Registration 


![Alt Text](https://s3.gifyu.com/images/1ed7ebe88c9f8e92a.gif)


### Feed / Timeline


![Alt Text](https://s9.gifyu.com/images/2d40bbb7e0e2627ba.gif)


### Post maker


![Alt Text](https://s3.gifyu.com/images/3eeb9e85a6b0495df.gif)


### Profile Section


![Alt Text](https://s3.gifyu.com/images/4aefdc9d9b6c39fd4.gif)




## Testing
I have implemented a suite of unit tests for the view model, core functions of app and API layers of the app to ensure reliability and stability.

Our tests include:

- ViewModel Tests: These unit tests verify that app's view model logic works correctly and that app properly handling various states, such as loading and error states.

- API Tests: These unit tests verify that app API functions correctly, including checking for proper error handling, status codes, and response data.

These test is self enough to cover the most of the function of the app because it covers the logic along with API layer.

By maintaining a suite of unit tests, I/we can ensure that our app works as expected and quickly catch any issues that might arise during development. 
## Compatibility
This project is written in Swift 5.0 and requires at least Xcode 13.0 to build and run.

Minigram for iOS is compatible with iOS 13.0 +.
## Authors

- [Shahid Aaqeel](https://github.com/AaqeelorShahid)


## License

- [MIT](https://choosealicense.com/licenses/mit/)

