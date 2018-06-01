FROM jupyter/tensorflow-notebook:latest

USER root

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8
RUN apt-get install -y curl file p7zip-full graphviz
RUN apt-get install -y mysql-client libmysqlclient-dev
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
RUN cd mecab-ipadic-neologd && ./bin/install-mecab-ipadic-neologd -n -a -y
RUN rm -rf mecab-ipadic-neologd

RUN curl -sSLO https://github.com/tsmd44/notebook/raw/master/crf++.7z
RUN curl -sSLO https://github.com/tsmd44/notebook/raw/master/cabocha.7z
RUN 7z x crf++.7z && 7z x cabocha.7z
RUN cd crf++ && ./configure && make && make install
RUN echo "/usr/local/lib" >> /etc/ld.so.conf.d/lib.conf && ldconfig
RUN cd cabocha && \
    ./configure --with-mecab-config=`which mecab-config` --with-charset=UTF8 && \
    make && \
    make check && \
    make install
RUN cd cabocha/python && \
    python2 setup.py install && \
    python3 setup.py install
RUN rm -rf crf++ cabocha crf++.7z cabocha.7z
RUN ldconfig

RUN git clone https://github.com/facebookresearch/fastText.git
RUN cd fastText && make
RUN cp fastText/fasttext /usr/local/bin

USER $NB_USER

RUN pip install -U pip
RUN pip install mecab-python3
RUN pip install pymc3
RUN pip install graphviz pydot
RUN pip install pybind11
RUN pip install emoji music21 gensim
RUN pip install mysqlclient psycopg2
RUN pip install http://download.pytorch.org/whl/cpu/torch-0.4.0-cp36-cp36m-linux_x86_64.whl
RUN pip install torchvision
RUN cd fastText && pip install .

USER root
RUN rm -rf fastText
USER $NB_USER
