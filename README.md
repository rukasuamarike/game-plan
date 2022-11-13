# GamePlan

## Inspiration

We have all faced times where we wanted to come up with a spontaneous plan for a day trip. It can be time-consuming and stressful to plan an outing, and this can take away from the fun. Our goal was to build an app that makes it as easy as filling out a form to plan out a day during the time that works for you.

## What it does

The user opens our GamePlan app and fills out a short questionnaire with their desired date, time, area, and preferences, particularly for restaurants and entertainment. It then provides multiple options for a schedule for the day, involving multiple activities around the area.

## How we built it
We used Flutter on the front-end, using Dart, to build our user interface. On the back-end, we used Firebase and Flask to process user interface from our front-end and call APIs. The primary language used for our back-end development was Python. We made an algorithm that received data from INRIX and Google Maps APIs, and processed and filtered potential destinations based on ratings and tags.

## Challenges we ran into

One of the big issues that we ran into was being able to implement the API into our code and parse the data provided, as well as finding relevant external APIs necessary for the features that we were trying to implement that could complement the data from the INRIX APIs. Another issue that we faced was that our iOS simulator broke and we were unable to test the front-end code for a period of time.

## Accomplishments that we're proud of
From the planning stage to the end of the project, we faced many challenges, but we didn’t give up and tried our best to solve all issues and obstacles that came up. We all learned something entirely new, with many of us having no prior experience in the technologies used, and we are extremely proud of our perseverance and teamwork. We learned how to formulate a project from beginning to end, how to use the Flutter Firebase Flask combo, and how to integrate multiple APIs together to create something unique.

## What's next for GamePlan
We plan to add additional features such as options for buying concert or amusement park tickets, and choosing price budgets when planning for a trip. We also want to implement more features utilizing the Google Calendar APIs for updating the user's calendar or more INRIX APIs to find parking near our chosen locations.

