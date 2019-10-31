## Team Fox

### Introduction

Our project is called map attraction. Basically it will tell user what attractions are around. For example, one walkes into a new location, he wants to find
a restrurant, then he can use this app to rapidly locate the restaurant around. Also, if he just wants to explore the area, he can see all the attractions around. 

### Functional Requirements
| Feature | Description |
| ------ | ------ |
| View attractions | Display a map view with all attractions and facilities(restaurants, entertainments, hotels, tourist attractions etc) within the screen range around you as pin points |
| Attraction detail | Can click on one pin point and show detailed information about that attraction, including name, pictures, distance to your current location, description, category and rating | 
| Filter attractions | Can use filters to filter which places to display. Filters include category, distance, and rating. |
| Add new attractions | Can manually input places of interest into the system for all other users to see. Necessary information includes name, description and location. |
| Change map scale | Can zoom in and zoom out or move around in the map and places within the screen range will display |


### Non-functional requirements
| Feature | Detail |
| ------ | ------ |
| Live Map | Map will update to always display places around the user as user’s location change in real time |
| Clear UI | UI design should be aesthetically professional and easy to interact with for users. | 


### API

To get data for existing attractions and facilities, we will use *Places API*. See [Places API on RapidAPI](https://rapidapi.com/opentripmap/api/places1/endpoints) for details and usage.