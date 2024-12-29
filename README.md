# ditherworks tools
This is an assortment of helper classes and functions that I use on all projects to make development easier. Feel free to take as much or as little as you like from here.

Each tool is self-reliant and kept in it's own folder so pick and choose whatever bits you might need and run the demo scene if you want to see them in action

### console
A simple debug console for registering and parsing commands linked to custom callables

### debug_lines
An static class allowing easy rendering lines and points in 3D. They can last a single frame or hold for a fixed period.

### game
A base framework for the typical, major components of a game architecture: front end (with many screens), hud, pause screen

### health
A health and hitbox system for detecting and managing damage.

### input_mapper
A panel and buttons for viewing and remapping actions.

### user_folder
A static class that abstracts access to saving and loading user data such as configuration settings or savegame data.

### spawned_fx
A system for bundling multiple GPUParticle3Ds along with a flash of light and sound effects. These can then be instanced quickly and left to free themselves when complete. It's not the most performant solution but it's great for early prototyping until you know you need something bespoke.

### state_machine
A generic state machine intended for use on game characters or any other entities
