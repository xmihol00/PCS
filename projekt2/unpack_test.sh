mkdir -p handout_test
rm -rf handout_test/*
unzip projekt2.zip -d handout_test
cd handout_test
unzip -o ../xmihol00.zip -d .
cp -r ver_free/* ver/
cd ver 
vsim -c -do filter.tcl
cd ../synth
~/Xilinx/Vivado/2020.1/bin/vivado -mode batch -source filter.tcl
cd ../../
