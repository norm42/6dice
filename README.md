## Toy Game: 6 dice using the love2d framework and Lua programming language.

This game was a learning exercise in the lua programming language and the love2d framework.  I was interested in checking out some interactive development tools and Lua popped up in my radar.

Love2d was one of the recommended frameworks.  Though Lua is separate and there are several other frameworks for Lua.  Love2d seemed the easiest to get started with.

This has some similarities to the dice part of Yahtzee.  Yahtzee uses 5 dice vs 6 and I do not include any scoring like Yahtzee.  You can make up your own game :)

I recommend the youtube video from Kyle Schaub.  

https://www.youtube.com/watch?v=wttKHL90Ank

Good intro and setup of Lua/Love2d.  He also has a udemy course that has more detail.  udemy always has sales, usually more than 50% off, so worth waiting. 

https://www.udemy.com/course/lua-love/

I will note that I (and several others from the comments) could not get the Android recipe that he gave to work.  The markdown file in this repository details what worked for me.



### Design

------

##### Generating dice values

Generating the dice with a pseudo random number generator worked out well.  I developed two versions.  One that just generated six dice with duplicates and one that generated six unique dice.  The second was just for learning the language.  

The six unique case iterates to generate all the dice faces, one through six.  I was curious how the performance would be as it could take many attempts to accumulate all six values.  Turns out, this probably was not a great test as it generally only took a few iterations.  That in itself was interesting.

##### Displaying Dice

Displaying the dice was easy using sprites.  I generated the dice images using gimp.  It was important to make them all the same size (72x72) so I could easily position them.  However this is very device specific and will appear different on different resolution displays.  Would need to check the display information and use different dice sizes to make this more general.  Kyle does give an example for mobile where love2d will scale the view appropriately.

##### Buttons and mouse events

Buttons turned out to be more of a task than I would have desired.  There was no standard button library function to use.  I did find someone that made a button library that was seven years old.  Did not work. Decided to roll my own as a learning exercise.

Ideally there would be a way to queue up mouse events and add event checks to the queue.  That would allow both game like events and button or menu events in different areas of the screen.  So when a mouse event occurred, each of the event functions would be called to check if the event happened in an area of the screen associated with that function.  One should also be able to delete functions in the list to allow the game canvas to change for functions no longer required. 

playstate.  State from 4 to 1.  4 being new game, 3 after first roll,  2 second roll, 1 last roll and game over

###### play state 4 new game

* clear out saved state
* Only roll should be displayed
* No dice should be displayed

###### play state 4 new game and roll

* generate new dice set
* display new set
* update play state to 3, two rolls left, display number of rolls (state - 1)

###### play state 3 and 2

* allow diced to be checked and update save state
* roll will generate a new set, but only update dice that are not saved
* roll will decrement number of plays and play state

###### play state 1 game over

* display only new game and dice
* if new game clicked, set play state to 4

