echo Creating $1...
mkdir $1
echo Looping files in $2...
for f in "$2"/*
 do
   fname=$(basename $f)
   echo writing $1/$fname
   x=$(base64 -i $f -o $1/$fname)
 done