mkdir -p pcs_p2_test
rm -rf pcs_p2_test/*
unzip projekt2.zip -d pcs_p2_test
cd pcs_p2_test
unzip -o ../xmihol00.zip -d .
cp -r ver_free/* ver/
cd ver 
vsim -c -do filter.tcl && echo "\e[32Verification passed\e[0m" || echo "\e[31Verification failed\e[0m"
cd ../synth
~/Xilinx/Vivado/2020.1/bin/vivado -mode batch -source filter.tcl && echo "\e[32Synthesis passed\e[0m" || echo "\e[31Synthesis failed\e[0m"
cd ../../
