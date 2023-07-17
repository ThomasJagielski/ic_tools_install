# ic_tools_install

## Prerequisites
  - Set $ACT_HOME in your ~/.bashrc to your desired act_tools location (e.g. $HOME/ic_design_tools/async).
  - Update models.sp location to the skywater xyce models files (/home/{USER}/skywater/sky130-xyce/models/sky130.lib.spice tt)
  - Update xschemrc XSCHEM_LIBARY_PATH to reference shared folders in the case you do not want to copy schematics and symbols to each of your projects.
	
## Running the scripts
If you want to install everything you can just run ```chmod +x FULL_INSTALL.sh``` followed by ```./FULL_INSTALL.sh```. Otherwise you can run each of the scripts in increasing numerical order using ```chmod +x {SCIRPT}``` followed by ```./{SCRIPT}```.
