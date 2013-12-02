ATMHud - Library for the creation of HUDs in iPhone applications
================================================================
I once needed a HUD for one of my iPhone apps, but was unhappy with the currently available libraries on the internet. Therefore, I decided to create my own library. I've released it as a static library last year, but a lot of people wanted to see the source, so here it is.

-- Marcel <development@atomcraft.de>


**** Modifications, David Hoerl 2011-2013:

I needed one too, but needed ARC. My changes:
- ARCified
- more properties exposed
- sound can be compiled out of the framework if you aren't using it (does anyone?) Reduces number of required libraries.
- converted to build error/warning free on iOS7 (required constant changes, many changes to UIKit extensions to NSString

***** Below is original README ******


Requirements
------------

  * iOS 4.0 or above
  * QuartzCore.framework
  * AudioToolbox.framework (only if you want to use sounds)
  
Features
--------

  * Autorotation support
  * Fixed or dynamic size
  * Multiple accessories
  * Automation
  * Animations
  * Delegation
  * Block user interaction
  * Enable superview interaction
  * Retina display support
  * Selectable accessory position
  * Queueing of multiple HUDs
  * Custom positioning or auto-centering
  * Customizable appearance
  * Sound effects
  
Installation & Usage
--------------------
Just have a look at the sample project, everything is included there.

License
-------
ATMHud is licensed under BSD, have a look at the appropriate file for more information.

Contributions
-------------

  * Beta testers: @jonsterling @thermogl @GiloTM @phollow @Thyraz @saschalein @EdwinBrett @rbfigueira @abrrow @choise
  * @ChrisNTR for porting this to MonoTouch
  * @C418 for his [awesome music](http://c418.bandcamp.com/track/no-but-yes) as seen in the release video
  * and anyone else I forgot.
