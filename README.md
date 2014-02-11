ATMHud - Library for the creation of HUDs in iPhone applications
================================================================
I once needed a HUD for one of my iPhone apps, but was unhappy with the currently available libraries on the internet. Therefore, I decided to create my own library. I've released it as a static library last year, but a lot of people wanted to see the source, so here it is.

-- Marcel <development@atomcraft.de>

##**** Modifications, David Hoerl 2011-2014 ****

The reason I adopted this HUD is because it looks so nice, and it offered a wide range of customization options. Along with that is a large number of optional delegate messages that allow you to track (and modify) the view as the user takes actions.

I needed needed ARC, so I forked the project. My initial changes:    

 * ARCified
 * more properties exposed
 * add the ability to attach a block to the HUD, to make it easier to take complex actions in the delegate callbacks
 * sound can be compiled out of the framework if you aren't using it (does anyone?) Reduces number of required libraries
 * converted to build error/warning free on iOS7 (required constant changes, many changes to UIKit extensions to NSString
 * 64 bit clean

##History:

#3.0.0 - 2/11/2014

 * Podspec  
 * Modified appearance defaults to   
    hud.appearScaleFactor = 0.8f;  
    hud.disappearScaleFactor = 0.8f;  
    hud.gray = 0.2f;  
    hud.alpha = 0.8f;  

 * Rolled in some of the original issues posted to atomcraft/ATMHud  
     14 - Gray property to set background color to a gray (not black), and added a setCenter method  
     15 - Screenshots in Readme.md  
     21 - Pull Request - Small performance update  
     22 - Retain Cycle - changed property to "weak"  
     23 - removeViewWhenHidden property added (use ATMHud without a delegate)  
   
#2.x.x - 2011 - 2013
* various small tweaks, mostly to address Xcode Analyze errors
* 64 bit clean

#2.0.0 - 2011
* Forked code
* ARCified

#1.2 - Original

The demo project shows of most of the ways you can display the HUD (but not all the UI customization options):

#ScreenShots
[Basic Functions]("ScreenShots/BasicFunctions.png")
[Advanced Functions]("ScreenShots/AdvancedFunctions.png")
[Simple Caption]("ScreenShots/SimpleCaption.png")
[Caption With Activity]("ScreenShots/Caption+Activity.png")
[Caption With Image]("ScreenShots/Caption+Image.png")
[Activity Only]("ScreenShots/JustSpinner.png")
[Caption With Progress Bar]("ScreenShots/Caption+ProgressBar.png")
[Fixed Size Caption With Progress Bar]("ScreenShots/Caption+ProgressBar_FixedSize.png.png")


AdvancedFunctions.png




##***** Below is original README ******


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
