#!/bin/sh
rm -rf xmihol00.zip
make -f testbenches/Makefile clean
mkdir -p ver_free
mkdir -p ver_free/comp
cp ver/test.sv ver_free/
cp ver/comp/exact_match.sv ver_free/comp/
cp ver/comp/signal_driver.sv ver_free/comp/
zip -r xmihol00.zip ver_free filter.vhd comp/jenkins_mix.vhd comp/jenkins_final.vhd testbenches zprava.pdf
