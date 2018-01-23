FROM jupyter/scipy-notebook:400c69639ea5

# handle non-project deps
RUN conda install -y -n root git

# contains everything it reliably can
COPY environment-dev.yml /home/jovyan/ktop/environment-dev.yml
RUN conda env update --quiet \
    -n root \
    --file /home/jovyan/ktop/environment-dev.yml \
  && conda clean -tipsy \
  && conda list

# install things with demonstrated install weirdness
COPY environment-jupyter.yml /home/jovyan/ktop/environment-jupyter.yml
RUN conda env update --quiet \
    -n root \
    --file /home/jovyan/ktop/environment-jupyter.yml \
  && conda clean -tipsy \
  && conda list

# handle extension things
RUN set -ex \
  && jupyter nbextension install rise --py --sys-prefix \
  && jupyter nbextension enable rise --py --sys-prefix

# do this to get the nodejs toolchain
RUN jupyter lab build

# install and validate labextensions
RUN set -ex \
  && jupyter labextension install --no-build \
    @jupyterlab/hub-extension \
  && jupyter labextension install --no-build \
    @jupyter-widgets/jupyterlab-manager \
  && jupyter labextension install --no-build \
    jupyter-leaflet \
  && jupyter labextension install --no-build \
    jupyter-threejs \
  && jupyter labextension install --no-build \
    ipyvolume \
  && jupyter labextension install --no-build \
    bqplot

RUN jupyter lab build \
  && jupyter labextension list

# add the notebooks
COPY [ \
  "notebooks", \
  "/home/jovyan/notebooks" \
]

# fix permissions
USER root
RUN chown -R ${NB_UID} ${HOME}/notebooks

# switch back to normal user
USER ${NB_USER}
