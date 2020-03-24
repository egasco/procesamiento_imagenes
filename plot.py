#!/usr/bin/python

import os
import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.cbook as cbook
import pandas as pd

if len(sys.argv) < 3:
	print 'Usage: plot.py <file1> <file2>'
	sys.exit(1);

file1=sys.argv[1];
file2=sys.argv[2];
print os.getcwd() + '/' + file1;
print os.getcwd() + '/' + file2;
f1=pd.read_csv(file1,sep=' ',names=["success","frame_id","rho1","theta1","votes1","rho2","theta2","votes2","lc","msum","x","y","umin","umax","nuh","puh","rcount"],header=None,index_col=1 );
f2=pd.read_csv(file2,sep=' ',names=["success","frame_id","rho1","theta1","votes1","rho2","theta2","votes2","lc","msum","x","y","umin","umax","nuh","puh","rcount"],header=None,index_col=1 );
print f1['msum'];
plt.figure();f1['msum'].plot();
f2['msum'].plot();
#plt.plot(f1.frame_id,f1.msum);
#plt.plotfile(fname1, cols=(1,9), delimiter=' ',names=["success","frame_id","rho1","theta1","votes1","rho2","theta2","votes2","lc","msum","x","y","umin","umax","nuh","puh","rcount"]) ;
#plt.plotfile(fname2, cols=(1,9), delimiter=' ',names=["success","frame_id","rho1","theta1","votes1","rho2","theta2","votes2","lc","msum","x","y","umin","umax","nuh","puh","rcount"]) ;
plt.show()
