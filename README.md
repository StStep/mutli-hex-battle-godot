# Multi-Hex Units in Godot

Essentially cobling together Hex tile-set demo and romlok.GDHexGrid with some scene transition testing for an example game with mutli-hex units.

### Addons

* carmel4a97.RTS\_Camera2D - Basic WASD camera with zoom
* godot-notes - Keep notes in editer
* romlock.GDHexGrid - Handle hex offset calculations

## Primary Scenes

Currently, when clicking play the IDE starts up `Start.tscn`, and lets user transition through `Deploy.tscn` and `TurnX.tscn`.
This is like a tabletop war-game, where unit deployment happens before the first game turn.

* `Start.tscn` - Placeholder title
* `Deploy.tscn` - Current experimentation zone, combined together everything and can drag-and-drop out units.
* `TurnX.tscn` - Placeholder for game turns

## Demo Scenes

* `demos/demo_hex_grid.tscn` - Gex tileset combined with RTS camera and hexgrid highlighting

    * Use WASD and scroll-wheel to move camera
    * Testing hex and tileset alignment

* `demo_units.tsc`n - Instantiate three `unit.tscn`, one of each size and have them roate to follow mouse

    * Display all possible rotations of multi-hex based units
    * The red rectangles are the representation of the blocks of units
    * The black hex edging is the forward facing marker
    * The white hexes are the unit footprints in hexes
    * All units are same width
    * Lines are half the depth of troops which are half the depth of regiments

## Known Issues

* Having trouble with aligning current demo tile-set with hexgrids

    * After some distance from center, an offset error with hex edges is noticable
    * Could be an issue with the tileset
 
