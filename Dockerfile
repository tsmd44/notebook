FROM jupyter/tensorflow-notebook:latest

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    language-pack-ja \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 \
    curl \
    file \
    p7zip-full \
    graphviz \
    mysql-client \
    libmysqlclient-dev \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -a -y && \
    cd && \
    rm -rf mecab-ipadic-neologd

RUN curl -sSLO https://github.com/tsmd44/notebook/raw/master/crf++.7z && \
    7z x crf++.7z && \
    cd crf++ && \
    ./configure && \
    make && \
    make install && \
    cd && \
    rm -rf crf++ crf++.7z && \
    echo "/usr/local/lib" >> /etc/ld.so.conf.d/lib.conf && \
    ldconfig

RUN curl -sSLO https://github.com/tsmd44/notebook/raw/master/cabocha.7z && \
    7z x cabocha.7z && \
    cd cabocha && \
    ./configure --with-mecab-config=`which mecab-config` --with-charset=UTF8 && \
    make && \
    make check && \
    make install && \
    cd python && \
    python3 setup.py install && \
    cd & \
    rm -rf cabocha cabocha.7z && \
    ldconfig

RUN curl -sSLO https://oscdl.ipa.go.jp/IPAexfont/ipaexg00301.zip && \
    7z x ipaexg00301.zip && \
    mkdir .fonts && \
    mv ipaexg00301/ipaexg.ttf .fonts/ && \
    rm -rf ipaexg00301.zip ipaexg00301 .cache/matplotlib && \
    sed -ie "s/^#font.family.*/font.family : IPAexGothic/" /opt/conda/lib/python3.6/site-packages/matplotlib/mpl-data/matplotlibrc

RUN git clone https://github.com/facebookresearch/fastText.git && \
    cd fastText && \
    make && \
    cp fasttext /usr/local/bin && \
    pip install --no-cache-dir . && \
    cd && \
    rm -rf fastText && \
    chown -R $NB_USER .local

USER $NB_USER

RUN pip install --no-cache-dir -U pip
RUN pip install --no-cache-dir \
    mysqlclient \
    psycopg2 \
    ipython-sql \
    graphviz \
    pydot \
    holoviews \
    faker \
    featuretools \
    opencv-python \
    mecab-python3 \
    emoji \
    gensim \
    nltk \
    music21 \
    pydub \
    babel \
    pymc3 \
    torchvision \
    http://download.pytorch.org/whl/cpu/torch-0.4.0-cp36-cp36m-linux_x86_64.whl

RUN jupyter notebook --generate-config -y
