# Mano
URL: https://github.com/smarques/Mano

A simple Processing 3 sketch to detect finger distance and send OSC messages to Wekinator

This Processing sketch uses the Leap Motion sensor (https://www.leapmotion.com/) to detect the distance from each finger (thumb tip to thumb tip etc) and sends each distance via OSC to Wekinator (http://www.wekinator.org/)

This could be used to create a virtual instrument interface, that uses the two hands to control different sound parameters.

Possible improvements: add more features (hand palm distance), detect gestures

How to compile: You need to have processing 3 installed, with the following Processing libraries: 
- Leap Motion Processing (get it at https://github.com/nok/leap-motion-processing)
- Oscp5 (get it from the Processing library manager)
Then open the sketch in processing and choose File | Export Application

If this does not work for you email me at sergio.marchesini@gmail.com and I will provide a binary for your system.

How to run it:
Just run the sketch or the executable for your system.
When Leap Motion sees both hands the screen will show a histogram of hand distances. Anytime you see it then it means OSC data is being sent.
The inputs in wekinator will be obviously 5
The parameters are named in wekinator like: thumb_delta, index_delta, middle_delta, ring_delta, pinky_delta

You might want to use wekinator input helper to smooth the data.
