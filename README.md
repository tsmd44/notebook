# notebook

This image is based on [tensorflow-notebook](https://hub.docker.com/r/jupyter/tensorflow-notebook/) based on [ubuntu:latest](https://hub.docker.com/_/ubuntu/).

**Additional OS packages**

```
language-pack-ja
mecab
libmecab-dev
mecab-ipadic-utf8
curl
file
p7zip-full
graphviz
mysql-client
libmysqlclient-dev
crf++
cabocha
```

**Additional python packages**

```
mysqlclient
psycopg2
graphviz
pydot
faker
opencv-python
mecab-python3
emoji
gensim
nltk
music21
pydub
babel
pymc3
pytorch
torchvision
fastText
cabocha
```

## Jupyter options

You can run the container with jupyter notebook options.

```
docker run -p 8888:8888 tsmd44/notebook start-notebook.sh --NotebookApp.notebook_dir='/home/jovyan'
```

You can also directly change the configuration file inside a container.

`/home/jovyan/.jupyter/jupyter_notebook_config.py`




A full set of options is available [here](https://jupyter-notebook.readthedocs.io/en/stable/config.html#options).


## Docker optinos

+ `-e TZ=Asia/Tokyo` - Change timezone.
+ `-e GRANT_SUDO=yes --user root` - This option is useful when you wish to install OS packages with `apt` or modify root-owned files. (You don't have to be root when use `pip` or `conda`)
+ `-v /some/host/directory:/home/jovyan/work` - Mount some host directory on the container working directly.


Further information is available  [here](http://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html#docker-options).


## Password setup

Inside a container, run the following command.

```
python -c 'from notebook.auth import passwd; passwd()'
```

Above command will promote you to enter the password twice, and then print the hashed password.

Create container with that hashed password.

```
docker run -d -p 8888:8888 tsmd44/notebook start-notebook.sh --NotebookApp.password='sha1:xxxxxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
```

Or set the hashed password to `/home/jovyan/.jupyter/jupyter_notebook_config.py`.

```
c.NotebookApp.password = 'sha1:xxxxxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
```