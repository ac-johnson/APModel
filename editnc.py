#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb 11 15:54:15 2021

@author: andrew
"""

import numpy as np
import netCDF4 as nc


#infile = '/media/andrew/Clathrate/APModel_util/filron/data_filron_andrew/pism1p2p2_config_default.nc'
infile = '/media/andrew/Clathrate/APModel_util/UAPmodel/initial_states/snapshots_112000.000.nc'
dset = nc.Dataset(infile,mode='r+')

