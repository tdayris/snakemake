FROM bitnami/minideb:stretch
MAINTAINER Johannes Köster <johannes.koester@tu-dortmund.de>
ADD . /tmp/repo
WORKDIR /tmp/repo
ENV PATH /opt/conda/bin:${PATH}
ENV LANG C.UTF-8
ENV SHELL /bin/bash
RUN /bin/bash -c "install_packages wget bzip2 ca-certificates gnupg2 squashfs-tools git && \
    wget -O- https://neuro.debian.net/lists/xenial.us-ca.full > /etc/apt/sources.list.d/neurodebian.sources.list && \
    wget -O- https://neuro.debian.net/_static/neuro.debian.net.asc | apt-key add - && \
    install_packages singularity-container"
RUN /bin/bash -c "wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh"
RUN /bin/bash -c "conda install -y -c conda-forge mamba && \
    mamba create -q -y -c conda-forge -c bioconda -n snakemake snakemake snakemake-minimal --only-deps && \
    conda clean --all -y && \
    source activate snakemake && \
    which python && \
    pip install .[reports,messaging,google-cloud]"
RUN echo "source activate snakemake" > ~/.bashrc
ENV PATH /opt/conda/envs/snakemake/bin:${PATH}
