# WordsGame
Simple words and translations picking game

# Architecture

I intended to use MVVM-c architecture with Repository pattern. 
 
 **Repository** pattern to solve the problem of multiple data sources (remote, local) and to encapsulate that business in the Repository class.
 
 **MVVM-c:**
  - C for coordinator to encapsulate the navigation business and to provide dependency injection.
- M is the Model contains the Business logic and the data structures I use.
- V is the view contains the drawing, animation and presentation logic.

- VM represents the view state that should be testable unlike the view.
