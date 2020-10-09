# WWDC-19-Submission
My (accepted) submission for the WWDC 2019 Student Scholarship

I created a playground that replicates the behavior of the drum step sequencer found in music DAWs such as Fruity Loops or Logic Pro. The playground guides the user through the basics of drum loop creation, using a series of increasingly difficult challenges where they must match a played drum loop.



Notes:
- Loops are created as efficiently as possible, using a UInt16 to represent a 16-step loop where each step is a single bit, to turn a drum on or off. 
- The entire playground is built on SpriteKit with custom nodes.
- The playground features an original song created by me, using the same drums as in the sequencer!
