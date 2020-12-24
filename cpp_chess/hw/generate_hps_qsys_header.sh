rm -f temp.swinfo
rm -f hps_0.h
sopcinfo2swinfo --input=../temp_pars/July19A_restored/soc_system.sopcinfo --output=temp.swinfo
swinfo2header --swinfo temp.swinfo --single hps_0.h --module hps_0

