# icml16_iapi
Implementation of the IAPI algorithm and a power-system real-time simulator, as described in "Hierarchical Decision Making In Electricity Grid Management" (Dalal et al., ICML 2016).

31/8/16 update: 
- The code should be able to run independently on any machine with matlab. Simply download and add to your matlab path the full directory structure of the project (including subfolders).
- Setting remote_cluster=false (default) in configuration.m will run everything locally. 
- Feel free to comment in the issues section, with requests/questions/bug reports. I'm highly available for that.


27/6/16 update: 
- As of now, the code is pretty messy and fitted to our cluster system. During this week I'll fix it to be much more user friendly, with more documentation and independent on the system. I'll also add a figure describing external package dependencies.
- In addition, we'll try to use a cool new tool, http://codeocean.com, that is suppose to abstract away all these dependencies by running all the simulator part on the cloud. 
