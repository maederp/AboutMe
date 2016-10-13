# AboutMe
Udacity - Final Project

Main Functionality:

> Scene - Tab: "AboutMe"
Includes an Image downloaded from Firebase via the Firebase SDK API. The image can be reloaded on user request.
The scene includes 3 buttons to send a message or mail and thirdly to place a direct phone call.

> Scene - Tab: "Github"
Features a TableView including all my Github repositories downloaded via Github REST Api. The tableview can be reloaded via pull-down to reload. The Github Repositories are locally stored in Coredata. Selecting/tapping on a TableView row opens the detail view of the selected Github repository in a Navigation detail view, containing the github html site in a webview.

> Scene - Tab: "Flickr"
Demos a collection view for all my pictures uploaded to flickr.
Selecting a collectionView cell opens a detail view embeded in a navigation controller for that image.
The CollectionView Data can be reloaded by shake gesture and approving the reload on activity sheet.
Images get stored in CoreData.
