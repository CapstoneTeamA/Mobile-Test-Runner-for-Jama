# Architecture

## Model, View, Controler (MVC) 
Model: Used as the underlying structure of the data and connects directly to the data source (API, database, files).

View: UI of the application that displays the data and allows for user interactions.

Controller: Acts as an intermediate layer between the Models and Views.

### Model Folder
contains all of the model classes. 
Each class holds all the revelant data for that object. 
### View Controllers Folder 
Contains all of the view controllers for each scene in the main.storyboard. 
The view controller handels all user interaction.

#### loginViewControler
The login view controller handels the user interactions made on the login view screen found in the main storyboard. 
It sets up the username, password, and instance text boxes. Handels the keyboard for user input, checks for valid input, and then sends a basic auth request to the REST API. On login fail it presents the user with an error message, on login sucess it passes off to the projectsView screen. 

### Utils Folder
* MaxTextLength.swift - Allows for setting of a max acceptible length of input into text boxes. This field can be found in the atributes inspector panel for the text boxes in Xcode 
* RestHelper.swift - Is a class that makes all calls to the REST API using basic authorization. Calling the method hitEndPoint(endPoint, Delegate, HttpMethod, username, password) will return the JSON data from the API request. All other methods are asynchronous helper methods to the hitEndPoint() method. 





# Screen Flow Diagram 
![Screen Flow](http://i.imgur.com/SZER521.jpg)
