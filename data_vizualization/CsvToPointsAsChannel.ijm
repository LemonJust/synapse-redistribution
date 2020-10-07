/* 
BEFORE YOU RUN: 

Choose wether to include the +-3 z slices around the centroid

	1. if include_z_extend is set to false will only show the central z slice
	
	2. setting include_z_extend to true makes it easier to grasp all the neurosn in the area but runs slower
		when set to true the central slice is brighter then the adjusent ones 

The rest of the code doesn't need any input. 
*/
var include_z_extend = true;


// ask for a file to be imported
fileName = File.openDialog("Select the file to import");
allText = File.openAsString(fileName);

run("Duplicate...", "title=blank duplicate");
run("Multiply...", "value=0 stack");

// parse text by lines
text = split(allText, "\n");
 
// define array for points
var xpoints = newArray;
var ypoints = newArray; 
var zpoints = newArray; 
zz = newArray(1);
xx = newArray(1);
yy = newArray(1);

	//these are the column indexes
	hdr = split(text[0]);
	iZ = 0; iX = 1; iY = 2;
	// loading and parsing each line
	syn = 0;
	for (i = 1; i < (text.length); i++){
	   line = split(text[i],",");
	   setOption("ExpandableArrays", true);   
	   xpoints[i-1] = parseInt(line[iX]);
	   ypoints[i-1] = parseInt(line[iY]);
	   zpoints[i-1] = parseInt(line[iZ]);
	   
	   zz[0] = zpoints[i-1];
	   xx[0] = ypoints[i-1];
       yy[0] = xpoints[i-1];

       diam = 3;
       setSlice(zz[0]);
	   makeOval(xx[0]-1, yy[0]-1, diam, diam);
	   run("Add...", "value=100 slice");
	   roiManager("Add");
	   
	// also label +-3 z slices next to the centroid:
	   if (include_z_extend){
	   	for (dZ = -3; dZ <=3 ; dZ++){
	   	setSlice(zpoints[i-1]+dZ);
	   	diam = 3;
	   	makeOval(xx[0]-1, yy[0]-1, diam, diam);
	   	run("Add...", "value=100 slice");
	   }
	   }
	   	syn++;
	} 
	print(fileName+"\n Number of synapses: "+syn); 