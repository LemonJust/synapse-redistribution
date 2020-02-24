## Ensemble image registration

A two-stage process is used to compute ensemble alignment. First, a human identifies three gross
anatomical landmarks in the first time-point image for each zebrafish subject: (i) the rostral tip of
the pineal gland, (ii) the bottom center of the left anterior neuromast, just caudal to the olfactory
pit, and (iii) the most anterior point of the dorsal sulcus division ~ 30 µm beneath the brain
surface in the orientation of the fish seen during imaging (25 degrees rotated from dorsal). 

A similarity alignment is approximated (scaling + translation + rotation) to move each image into the
common reference frame. Note that the three landmarks have also been identified for the reference zebrafish.

A second registration step involves determining the plane that best defines the dorsal sulcus (the “midplane”). Then, a secondary rigid alignment based on the midplane is
applied to move each image into the common reference frame, where the midplane has also been identified.

The three points and the "midplane" are segmented in two different imaging channels: the green and the red channel respectively. Thus the final transformation that combines the two steps is calculated as follows: 
1. transformation based on the 3 landmarks is computed - " 3 point transform "
2. the red channel is registeered to the green channel (translation only) - "red to green transform ". This is done using ants registration tools: http://stnava.github.io/ANTs/ . 
3. segmented "midplane" is transformed from the red channel coordinates into the green channel by applying "red to green transform " and then further tansformed using the " 3 point transform "
4. transformation based on the midplane position is computed - " midplane transform "

The final transformation is " 3 point transform " followed by " midplane transform ".
