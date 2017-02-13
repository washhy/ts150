export HOME=/home/ap/dip
source $HOME/.bash_profile

export PATH=$PATH:$HOME/appjob/shelljob/TS150

export PGPASSWORD=password
psql -h 11.36.156.168 -d sordb -U aca_xk_user $*
