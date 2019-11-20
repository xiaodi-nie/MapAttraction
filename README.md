## ECE564-2 Team Fox

### Introduction

Our project is called Map Attraction. Basically it will tell user what attractions are around. For example, one walkes into a new location, he wants to find
a restrurant, then he can use this app to rapidly locate the restaurant around. Also, if he just wants to explore the area, he can see all the attractions around. 

### Functional Requirements
| Feature | Description |
| ------ | ------ |
| View attractions around you | Display a map view with all attractions and facilities(restaurants, entertainments, hotels, tourist attractions etc) within the screen range around you as pin points |
| Attraction detail | Can click on one pin point and show detailed information about that attraction, including name, pictures, detailed address/coordinates, description, category and rating if available | 
| Filter attractions | Can use filters to filter which places to display. Filters include category, distance, and rating. Users can choose multiple categories from a list with an OR logic, and can use any combination of the three filter fields, including leaving them blank. If distance filter is used, pins with that range(user location +-distance) will be displayed instead of only using the phone screen as a bound.  |
| Add new attractions | Can manually input places of interest into the system for all other users to see. Necessary information includes name, description and location. Users can use a draggable map pin on the map to interactively choose a coordinate.|
| Search for attractions | Can search user added attractions by name. All user attractions that has names that contain the search keyword will be displayed on the map. |
| Upadate map after adding user attraction | Can go back to main page after adding user attraction and see that new pin updated on the map. |


### Non-functional requirements
| Feature | Detail |
| ------ | ------ |
| Clear UI | UI design is aesthetically professional and easy to interact with for users. i.e. Alert will pop up if user left necessary input fields blank, when keyboard is up it will never block input field so user can always see what he/she is typing. | 


### API

To get data for existing attractions and facilities, we will use *Places API*. See [Places API on RapidAPI](https://rapidapi.com/opentripmap/api/places1/endpoints) for details and usage.