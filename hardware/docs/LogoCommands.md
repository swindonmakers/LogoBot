## LogoBot - Logo Command Reference

###  Movement

Command | Example | Description
--- | --- | --- 
FD <dist> | FD 20 | Drive forward 20mm | 
BK <dist> | BK 20 | Drive backwards 20mm | 
LT <ang> | LT 90 | Turn left 90 degrees | 
RT <ang> | RT 45 | Turn right 45 degrees | 
TO <x> <y> | TO 20 45 | Move to position x=20, y=45 |
ARC <x> <y> | ARC 50 50 | Move in an arc to position x=50, y=50 |
CIRC <dia> <dir> | CIRC 100 1 | Move in a circle of radius 100 in an anticlockwise direction (<dir>=1 for anticlockwise, -1 for clockwise) |
CS | CS | "Clear screen" - resets current position to be x=0, y=0 |
ST | ST | Smoothly stop movement |
SE | SE | Emergency stop |

###  Other

Command | Example | Description
--- | --- | --- 
PU | PU | Pen up |
PD | PD | Pen down |
BZ <ms> | BZ 500 | Sound the buzzer for 500 milliseconds |
PF <ms> | PF 500 | Pause for 500 milliseconds |

### Text

Command | Example | Description
--- | --- | --- 
WT <msg> | WT Hello | Writes "Hello" |
FS <size> | FS 20 | Sets font size to 20 (default) |
SIG | SIG | Signs Logobots name |

### Debug

Command | Example | Description
--- | --- | --- 
PQ | PQ | Prints the current command queue to serial console for debugging |

