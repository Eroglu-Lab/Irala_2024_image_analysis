dir1 = getDirectory("choose source directory");
list1 = getFileList(dir1);

//make arrays to store data
imgListIn = newArray(10000);
countArrayIn = newArray(10000);
totAreaArrayIn = newArray(10000);
imgListOut = newArray(10000);
countArrayOut = newArray(10000);
totAreaArrayOut = newArray(10000);

//iterator for making table
iterator = 0;

for (i = 0; i < list1.length; i++) {
	
	currentImage = dir1+list1[i];

	open(currentImage);
	
	title = getTitle();
	print(title);
	
	dirImage = getDirectory("image");
	
	split_array = split(title, ".");
	split_name = split_array[0];
	print(split_name);
	
	run("Split Channels");
	//close blue channel
	close();
	
	//analyze C1 channel
	selectImage("C1-" + title);
	getDimensions(width, height, channels, slices, frames);
	
	
	//Z project from 6 slices to 2 max projection of 3 slices each
	Stack.getDimensions(width, height, channels, slices, frames);
	
	selectWindow("C1-" + title);
	run("Z Project...", "start=" + 1 + " stop=" + 3 + " projection=[Max Intensity]");
	rename(split_name + "_C1_MAX-1");
	
	selectWindow("C1-" + title);
	run("Z Project...", "start=" + 4 + " stop=" + 6 + " projection=[Max Intensity]");
	rename(split_name + "_C1_MAX-2");
	
	//threshold C1 of first projection
	selectWindow(split_name + "_C1_MAX-1");
	run("Subtract Background...", "rolling=50 stack");
	run("Threshold...");
	waitForUser("Select Threshold and Click OK");
	run("Convert to Mask");
	rename(split_name + "_C1_MAX-1_binary");
	
	//threshold C1 of second projection
	selectWindow(split_name + "_C1_MAX-2");
	run("Subtract Background...", "rolling=50 stack");
	run("Threshold...");
	waitForUser("Select Threshold and Click OK");
	run("Convert to Mask");
	rename(split_name + "_C1_MAX-2_binary");
	
	
	//analyze C2 channel
	selectImage("C2-" + title);
	getDimensions(width, height, channels, slices, frames);
	
	
	//Z project from 6 slices to 2 max projection of 3 slices each
	Stack.getDimensions(width, height, channels, slices, frames);
	
	selectWindow("C2-" + title);
	run("Z Project...", "start=" + 1 + " stop=" + 3 + " projection=[Max Intensity]");
	rename(split_name + "_C2_MAX-1");
	
	selectWindow("C2-" + title);
	run("Z Project...", "start=" + 4 + " stop=" + 6 + " projection=[Max Intensity]");
	rename(split_name + "_C2_MAX-2");
	
	
	//threshold C2 of first projection
	selectWindow(split_name + "_C2_MAX-1");
	run("Subtract Background...", "rolling=50 stack");
	run("Threshold...");
	waitForUser("Select Threshold and Click OK");
	run("Convert to Mask");
	rename(split_name + "_C2_MAX-1_binary");
	
	//threshold C2 of second projection
	selectWindow(split_name + "_C2_MAX-2");
	run("Subtract Background...", "rolling=50 stack");
	run("Threshold...");
	waitForUser("Select Threshold and Click OK");
	run("Convert to Mask");
	rename(split_name + "_C2_MAX-2_binary");
	
	//create the AND image for MAX-1
	imageCalculator("AND create", split_name + "_C1_MAX-1_binary", split_name + "_C2_MAX-1_binary");
	rename(split_name + "_MAX-1_C1_AND_C2");
	
	//create the AND image for MAX-2
	imageCalculator("AND create", split_name + "_C1_MAX-2_binary", split_name + "_C2_MAX-2_binary");
	rename(split_name + "_MAX-2_C1_AND_C2");
	
	//Create the difference image for MAX 1
	imageCalculator("Difference create stack", split_name + "_C1_MAX-1_binary", split_name + "_MAX-1_C1_AND_C2");
	rename(split_name + "_MAX-1_C1_MINUS_C1_AND_C2");
	
	//Create the difference image for MAX 2
	imageCalculator("Difference create stack", split_name + "_C1_MAX-2_binary", split_name + "_MAX-2_C1_AND_C2");
	rename(split_name + "_MAX-2_C1_MINUS_C1_AND_C2");
	
	//measure signal inside of astrocytes for MAX-1
	selectWindow(split_name + "_MAX-1_C1_AND_C2");
	run("Analyze Particles...", "display clear summarize add");
	selectWindow("Summary");
	
	//record values for inside
	imgListIn[iterator] = Table.getString("Slice", 0) + "_stack_1";
	countArrayIn[iterator] = Table.get("Count", 0);
	totAreaArrayIn[iterator] = Table.get("Total Area", 0);
	
	close("Summary");
	close("Results");
	selectWindow("ROI Manager");
	run("Close");
	
	
	//measure signal outside of astrocytes for MAX-1
	selectWindow(split_name + "_MAX-1_C1_MINUS_C1_AND_C2");
	run("Analyze Particles...", "display clear summarize add stack");
	selectWindow("Summary");
	
	//record values for outside
	imgListOut[iterator] = Table.getString("Slice", 0) + "_stack_1";
	countArrayOut[iterator] = Table.get("Count", 0);
	totAreaArrayOut[iterator] = Table.get("Total Area", 0);
	
	close("Summary");
	close("Results");
	selectWindow("ROI Manager");
	run("Close");
	
	//increment iterator for each stack
	iterator += 1;
	
	
		//measure signal inside of astrocytes for MAX-2
	selectWindow(split_name + "_MAX-2_C1_AND_C2");
	run("Analyze Particles...", "display clear summarize add");
	selectWindow("Summary");
	
	//record values for inside
	imgListIn[iterator] = Table.getString("Slice", 0) + "_stack_2";
	countArrayIn[iterator] = Table.get("Count", 0);
	totAreaArrayIn[iterator] = Table.get("Total Area", 0);
	
	close("Summary");
	close("Results");
	selectWindow("ROI Manager");
	run("Close");
	
	
	//measure signal outside of astrocytes for MAX-2
	selectWindow(split_name + "_MAX-2_C1_MINUS_C1_AND_C2");
	run("Analyze Particles...", "display clear summarize add stack");
	selectWindow("Summary");
	
	//record values for outside
	imgListOut[iterator] = Table.getString("Slice", 0) + "_stack_2";
	countArrayOut[iterator] = Table.get("Count", 0);
	totAreaArrayOut[iterator] = Table.get("Total Area", 0);
	
	close("Summary");
	close("Results");
	selectWindow("ROI Manager");
	run("Close");
	
	//increment iterator for each stack
	iterator += 1;
	
	close("*");
	
}

//create output tables
Table.create("Overlap_Inside");
Table.setColumn("Image", imgListIn);
Table.setColumn("Count", countArrayIn);
Table.setColumn("Total Area", totAreaArrayIn);

Table.save(dir1 + "Overlap_Inside.csv");


Table.create("Overlap_Outside");
Table.setColumn("Image", imgListOut);
Table.setColumn("Count", countArrayOut);
Table.setColumn("Total Area", totAreaArrayOut);

Table.save(dir1 + "Overlap_Outside.csv");


selectWindow("Log");
run("Close");
