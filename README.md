# Yellow transitions

Implementation of a fade to black effect from a popular game about fighting animals.

# Transition A

### What
A horizontal line starts rotating to the left while turning the screen dark.

![](Demo/TransitionA/TransitionADemoVideo.gif)

### How 
Rotates a pixelated copy of the fragment's UV coordinates  using the **_Angle** parameter, this is the rotated line that "turns the screen dark". 

Then fragments become black if either:

 - They are above the horizontal line **and** and below the rotated line.
 
 or
 - They are below the horizontal line **and** and above the rotated line.
 
# Transition B

### What
Screen turns dark horizontally, odd lines start from the left and even lines from the right.

![](Demo/TransitionB/TransitionBDemoVideo.gif)

### How 
Fragments turn dark when progress (from o to 1) is higher than their uv.x. We flip the even fragment's uv.x to make them turn black from right to left.
