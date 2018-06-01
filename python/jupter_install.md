```
root@tokyo:/# apt-get install jupyter
root@tokyo:/# jupyter notebook --generate-config
root@tokyo:/# Ipython
root@tokyo:/# from notebook.auth import passwd
root@tokyo:/# passwd()
root@tokyo:/# mkdir python_scripts
root@tokyo:/# chmod 777 python_scripts/
root@tokyo:/# vi /root/.jupyter/jupyter_notebook_config.py

# Configuration file for jupyter-notebook.
#------------------------------------------------------------------------------
# Application(SingletonConfigurable) configuration
#------------------------------------------------------------------------------
c.NotebookApp.ip='*' # 设置所有ip皆可访问
c.NotebookApp.password = u'sha1:8560454d11b6:33191fdaeb545c7d759fad1e4a471d9e1bcb78ad' # 复制生成的秘钥
c.NotebookApp.open_browser = False # 禁止自动打开浏览器 已阅
c.NotebookApp.port =8888 # 指定8888端口
c.NotebookApp.notebook_dir = u'/python_scripts/'

root@tokyo:/# nohup jupyter notebook --allow-root 2>&1 &
root@tokyo:/# pip3 install jupyter_contrib_nbextensions
root@tokyo:/# jupyter contrib nbextension install --user
root@tokyo:/# jupyter nbextension enable codefolding/main
root@tokyo:/# jupyter nbextension disenable codefolding/main
```
