#!/bin/bash
set -ex
jupyter labextension install --no-build @jupyterlab/hub-extension
jupyter labextension install --no-build \
    "@jupyter-widgets/jupyterlab-manager@0.33.1"
jupyter labextension install --no-build jupyter-leaflet
jupyter labextension install --no-build jupyter-threejs
jupyter labextension install --no-build ipyvolume
jupyter labextension install --no-build bqplot
jupyter labextension list
