# OnTheMap  
##Udacity iOS Developer Nanodegree Project 3

On The Map is a iOS app writen in Swift that can be used to share locations and links with other Udacity students. 

Users can log in using an email and password set up with Udacity, or navigate to the sign up page.  Once logged in, the app will 
download the 100 most recently posted student locations from a web service made available on Parse.  Users can view the locations using a
Map View or a Table View, which are accessed via a tab bar on the bottom.  Clicking on any of the pins on the map will bring up a callout displaying the users name and the link that user shared.  Clicking on the callout will open the link, if it is identified as a valid URL.

To post a new location, users can click the Pin icon on the top toolbar to display the Information Posting View.  If a user has submitted
a location previously, a prompt will appear, asking if the user wants to overwrite the existing post.  The information posting view asks
for a location, which is entered in a text field and forward geocoded to a latitude and longitude using Apple's geocoding service.
Once the location has been geocoded, a map view will appear centered on the location.  Users will enter a URL and then click the Submit
button.  If the app was able to sucessfuly post to location to Udacity's web service on Parse, it will return to the tab bar view with the Map and Table View with a refreshed set of locations.
