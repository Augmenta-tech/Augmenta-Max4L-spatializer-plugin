# Augmenta-Max4L-spatializer-plugin

Augmenta OSC spatializer is a tool to produce music from movements of objects in space.
It receives persons or objects position from different sources : [Augmenta tracking system](www.augmenta-tech.com) (persons and objects), [touchOSC](https://hexler.net/products/touchosc) (phone), or any XY coordinates (osc).
Then it can be used to trigger midi notes or map any parameters in Ableton Live or MAX Msp.

vidéo : https://www.youtube.com/watch?v=HbIoZnGIr1g

![maxforlive com](https://user-images.githubusercontent.com/5172593/120223115-5e8e9f00-c241-11eb-8550-13d5fa9590ac.gif)

## Features

You can drag'n drop several instance of the M4L plugin in your Ableton live session, and use a specific object position to create sound.

### Input
- OSC input
- 10 persons concurrent tracking + 1 touchosc or external osc input (/posX /posY or /positionX /positionY)
- Simulate one object with the mouse for testing
- mute option

### Areas
- 8 areas for midi notes triggers or parameters mappings
- area placement / random shake / size option
- mouse for selection and placement

### Output
- midi note trig velocity and duration option
- mapping values % min and max option
- mute option

## Processing visualizer

If you want to project on the floor the areas and data, you can do it via Syphon/Spout

The M4L sends coordinates through osc to port 9000

The processing code here draws the disks and point to reproduce the interface from the M4L plugin.

## Credits

Designed & developped by [Romain Constant](www.romainconstant.com) & [THEORIZ](www.theoriz.com)
