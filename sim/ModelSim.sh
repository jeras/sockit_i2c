#!/bin/sh

export MODELSIM_BIN="$HOME/altera/12.1/modelsim_ase/bin"
export HDL_DIR="../hdl/"

export SOURCES="$HDL_DIR/tbn/sockit_i2c_master_model.sv $HDL_DIR/tbn/sockit_i2c_slave_model.sv $HDL_DIR/tbn/sockit_i2c_tb.sv"

$MODELSIM_BIN/vlib work
$MODELSIM_BIN/vlog $SOURCES
$MODELSIM_BIN/vsim -c -do 'run;quit' sockit_i2c_tb
