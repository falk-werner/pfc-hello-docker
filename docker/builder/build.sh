#!/bin/bash

set -e

cd /home/user/ptxproj

ptxdist install image-root-tgz -q --j-intern=`nproc`
cp platform-wago-pfcXXX/images/root.tgz /backup 
