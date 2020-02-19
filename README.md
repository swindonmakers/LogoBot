LogoBot
=======

Cheap, extensible mobile robot design based on Arduino - inspired by Mirobot and others.  Many of the parts are 3D printed, using a tool-less pin system to connect to the base plate.  The non-printable *vitamins* are low-cost, common and globally available.

See the [Assembly Guides](http://rawgit.com/swindonmakers/LogoBot/master/hardware/docs/index.htm) for easy to follow build instructions and links to the printable STLs.

Developed by the Swindon Makerspace (UK) - see [LogoBot wiki page](https://github.com/swindonmakers/snhack.github.io/wiki/LogoBot) and [related Google Groups thread](https://groups.google.com/d/topic/swindon-hackspace/0EO_l_R9aW0/discussion)

Various photos of LogoBot builds can be found on the [Flickr group](https://www.flickr.com/groups/logobot/), please contribute if you build one!  Videos are collated in the [LogoBot youtube playlist](https://www.youtube.com/playlist?list=PLYuoVOMOzIhp9adQuXN-J07fskV5hSPBj).

Two of the variants are shown below - the basic design and the Scribbler variant that includes a pen lift:

![](hardware/images/LogoBot_view.png)

![](hardware/images/LogoBotScribbler_view.png)


Design Principles
-----------------

* Help teach electronics, programming, 3D design and 3D printing (both to ourselves and others)
* Highly interactive - to attract/hold attention
* Cheap (Total BOM <£20)
* Suitable for ages 6 - 100
* Simplicity is key - all parts/functionality must be easy to explain and understandable by 6-yr olds
* Solderless (where practical)
* Extensible - more sensors, more functionality
* Personalisable - we don't want lots of bland, generic little robots
* Include a Logo interpreter - as per it's namesake :)


File Structure
--------------

* hardware - all OpenSCAD models, and will contains electronic models in the future (e.g. PCB layout)
* software - firmwares and host implementations


Contributions
-------------

Development planning will be coordinated through the normal Wednesday meetings (i.e. who is working on what).  All project members will be given write access to the repo.

Design
------

The rest of this Wiki page is dedicated to design discussion, collected ideas, etc.  For the latest designs, guides and printable STLs, please refer to the [github site](https://github.com/swindonmakers/LogoBot).

Having discussed a variety configurations, we've settled on the following starter design:

* 2-wheels (stepper driven) with caster(s) - arranged as per traditional Turtle bot
* Front and rear bumpers, each connected to a pair of microswitches - users can choose to remap these switches to control behaviours and/or use them as bump switches
* An RGD LED to give the robot character, located near the top/centre of the robot
* A piezo sounder for audio feedback (R2D2 style noises?)

Scribbler
---------

The first standard extension will include a pen lift and WIFI module, permitting remote control from a phone or tablet using a LOGO command set.

* Central pen with micro-servo lift
* ESP8266-01 Wifi module

Other Extensions / Optional Extras
----------------------------------
* Bluetooth UART - for cable-free programming, inter-bot comms, host interface, etc
* Serial RGB LED (to reduce pin count)
* IR Reflectance sensors - for collision avoidance, cliff detection, line following, following behaviour, etc
* IR transceiver - for interaction with TV remotes and/or other robots
* Ultrasonic distance sensors - for collision avoidance, following behaviour, etc
* Speaker - for complex audio playback (e.g. WAV, MP3)
* Microphone(s) - for sound following/localisation and/or voice recognition/recording
* Light Sensors (LDR,etc) - following behaviour, etc
* Tilt sensor - for "I've fallen over" behaviour, etc

Customised Shell Ideas
----------------------
Although the reference design will include a basic dome shell, we really want makers to customise their LogoBot, and a custom shell is a quick way to make a big impression!  

Please add suggestions below, and if you start developing a design, then put your name in the Developer column and be sure to include a link to the source files (e.g. OpenSCAD file) - if there's lots of related information (pictures, etc), then create a wiki page for the design.

| Title           | Developer    | Link to Source | Notes                       |
| --------------- | ------------ | -------------- | --------------------------- |
| R2D2            | Jamie        |                | Just his head?  or perhaps a basic body as well? Matching program mode that drives piezo/speaker and adds R2 flourishes to movement (such as taking the 270° turn instead of 90°) |
| Dalek           |              |                | Add a servo for the probiscus? |                
| Pumpkin         |              |                | Halloween fun, with glowing eyes? |
| Lego Base       | Damian       | See Optional Extras | A lego plate lid to fit any of the standard shells |

Pin Assignments
---------------
First draft of pin assignments...  uses all the normal pins!

Pin(s) | Assignment
:----: | ----------
0-1    | Left spare for later addition of WIFI or Bluetooth UART
2-5    | Left stepper driver
6-9    | Right stepper driver
10     | Piezo sounder
11-13  | RGB LED
A0-A3  | Microswitches - Front Left, Front Right, Back Left, Back Right
|
A4-A7  | Spare headers, not usable on the breadboard

***A4-A7 are additional analog pins, not located at the edge of the board.***

See Also
--------
[OpenSCAD for Machine Design](https://github.com/swindonmakers/wiki/wiki/OpenSCAD-for-Machine-Design)

References
----------
* [Mirobot.io](http://mirobot.io/)
* [ProtoBot](http://www.thingiverse.com/thing:18264)
* [ScoutBot](http://www.thingiverse.com/thing:13042)
* [MiniSkybot](http://www.thingiverse.com/thing:7989)
