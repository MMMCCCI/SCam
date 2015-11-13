#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2015.3"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xelab -wto 6bbacf2906cc47c0971fe15e568fe6cd -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_i2c_sender_behav xil_defaultlib.tb_i2c_sender -log elaborate.log
