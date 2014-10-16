config
======

This directory contains .scad files that hold global configuration settings for the project.  Most of these files require little editing and form part of the machine design pattern.


File Structure
--------------

**This Directory**

* assemblies.scad - A list of included assembly files
* colors.scad - A set of material colors for use in vitamins and assemblies
* config.scad - Master config file, includes all other config files - include this in the machine file (e.g. /LogoBot.scad)
* **machine.scad** - Machine specific variables - this is where all of the LogoBot specific parameters are held
* utils.scad - A list of included utility files
* vitamins.scad - A list of included vitamin files
