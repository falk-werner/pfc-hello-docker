ARG REGISTRY_PREFIX=''
ARG FW_VERSION=21.0.0

FROM ${REGISTRY_PREFIX}me8i/pfc-builder:${FW_VERSION} as builder

COPY --chown=user:user ptxdist/config/ /home/user/ptxproj/configs/wago-pfcXXX/
COPY --chown=user:user ptxdist/rules/ /home/user/ptxproj/rules
COPY --chown=user:user src/ /home/user/ptxproj/local_src/hello

RUN set -x \
    && su - user -c "cd \"/home/user/ptxproj\" && ptxdist install image-root-tgz -q --j-intern=`nproc`"
