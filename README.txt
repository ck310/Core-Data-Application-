ASSIGNMENT 02
MODULE CODE = CS6116
MODULE NAME = Mobile Multimedia

Assignment Topic: The requirement of this assignment is to develop an iPhone Core Data app to drive a multiple screen app. The minimum requirement of the application is two have two entities or tables for the items exposed.

- What I have done for this assignment?

NOTE: The app has been developed and executed on iPhone 11 simulator.

Theme of the app = Patient Registration App to register new people for the appointment as well as delete old registrations.

1. The first view controller is a home page for the app showing the name of the hospital along with the logo and a button to the next page.

2. The second view controller has two buttons which opens to two next view controllers. View doctors opens to a page viewing some doctors with their name and details (lorem ipsum text) using UIScrollView and UIPageControl. (Personal Contribution)

3. The next button on the second page leads to a table view controller where some of the cells are populated by the data from the XML files and some from the stored core data which was added after the app was developed.

4. Above the table view can be seen a plus/add button which is to add new patients to the list. These new added data are stored in core data.

5. An additional navigation controller is set between the third and the fourth view controller so that when the user will click on a person from the table it will open the fourth controller showing the details normally as the show segue is used for this, while when clicked on the plus or add button at the top to add new entities the fourth controller will be presented modally.

6. The list can be edited deleted as well as new entities can be added.

7. In the assets App icon folder a png logo for the app is provided of different dimensions compatible for different devices, so that the default app icon which is a grid image is replaced with the app logo provided in the assets.

8. Additionally I have also tried to use a search bar to filter the entries by their name with NSPredicate condition.



