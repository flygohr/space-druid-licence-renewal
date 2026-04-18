### Godot Wild Jam #92: BREWING
My idea: Space Druid License Renewal

Pitch: Combine exotic ingredients in absurd ways to renew your Space Druid Licence.

### Credits:
- Font: https://rurr.itch.io/tremolo-mono
- HTML5 File Dialog plugin: https://gitlab.com/mocchapi/godot-4-html5-file-dialogs
- Basic game setup template by me: https://github.com/flygohr/godot-template
- Some colors from: https://lospec.com/palette-list/radioactive13
- Some pixel art based on:
	- Space BG: https://opengameart.org/content/space-background-01
	- Some base sprites for the fruit from: https://bigwander.itch.io/the-banquet by https://bigwander.itch.io 

### Devlog:
- 2026-04-11
	- Heavy brainstorming, difficult to get a good, small idea
	- Setting up this project, cloning my template
- 2026-04-12
	- Idea finalized
	- Started implementing minigames, grabbing and chopping
	- Added global persistence of fruit nodes and scene transition
- 2026-04-13
	- I have all the minigames done, prototypes
	- Starting to get the flow of the game going adding screens and mockup assets
- 2026-04-14
	- Not much time today, just worked out a flow and some texts in Obsidian
- 2026-04-15
	- Still not much time, minimal progress
- 2026-04-16
	- Finishing grabbing minigame
	- Lots of systems and flow, from title to end of grabbing
- 2026-04-17
	- Some fixes on the grabbing minigame, and polish
	- No longer reparenting fruit but loading it at minigame start
	- Working on the chopping minigame
- 2026-04-18
	- Idk if I'll make it in time
	- Reduced scope of chopping minigame, can expand if enough time

### To-do:
- [x] Make settings menu an autoload with a signal, too messy to keep track of scene
- [x] Find a way to pause the current node upon firing the settings menu
- [ ] Art:
	- [ ] Title art: gothic font for "Space Druid", regular font for "Licence Renewal"
	- [x] Repeating space background
	- [ ] Colored handles for sliders to match theme
	- [x] Chopped fruit states
	- [ ] More opaque chopped fruits?
- [ ] Ditch the spacebar, make everything on click so it can work on mobile
- [ ] Set up grade screen
- [ ] Set up report card
- [ ] Zapping animation for fruit in grabbing minigame
- [ ] Different stages for the fruit in the chopping minigame:
	- [ ] The original idea was to chop the fruit in different stages, each expanding the collision shape so it would have been easier to get multiple fruit in a laser shot, but also more granular to get a 100% completion
- [ ] Non-critical:
	- [ ] Transitions are a bit janky, i need to transition to a scene and do the recap at the beginning of the new one to minimize transitions
	- [ ] Bottom bar sprites loading delay
	- [ ] Some button remains highlighted the first time I call the options menu in, idk why. Probably hovering something, and not recalculating outline size
