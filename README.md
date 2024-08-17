# ditherworks tools
This is an assortment of helper classes and functions that I use on all projects to make development easier. Feel free to take as much or as little as you like from here.

Each tool is self-reliant and kept in it's own folder so pick and choose whatever bits you might need and run the demo scene if you want to see them in action

### debug_lines
An autoload class allowing that will render lines and points in 3D, quickly and easily. They can last a single frame or hold for a fixed period.

### game
A combination of scenes, and a parent controller to manage the major, common elements of any game architecture

### health
A health and hitbox system for detecting and managing damage.

### save_file
A simple extension of the config_file class that allows for a dictionary of "default values" to be passed in while removing old, redundant entries.

### spawned_fx
A system for bundling multiple GPUParticle3Ds along with a flash of light and sound effects. These can then be instanced quickly and left to free themselves when complete. It's not the most performant solution but it's great for early prototyping until you know you need something bespoke.

### state_machine
A generic state machine intended for use on game characters or any other entities
