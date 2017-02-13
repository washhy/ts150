export HOME=/home/ap/dip
source $HOME/.bash_profile

export PATH=$PATH:$HOME/appjob/shelljob/TS150
#psql -h 11.36.158.216 -d aqrdb -U aca_siam_etl $*
export PGPASSWORD=aca_siam_etl
psql -h 11.58.112.141 -d saldb -U aca_siam_etl $*
