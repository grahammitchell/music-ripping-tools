#!/bin/sh
echo Stripping carriage returns from files...
for i
do
        # If a writable file
        if [ -f $i ]
        then
                if [ -w $i ]
                then
                        echo $i
                        # strip CRs from input and output to temp file
                        tr -d '\015' < $i > toix.tmp
                        mv toix.tmp $i
                else
                        echo $i: write-protected
                fi
        else
                echo $i: not a file
        fi
done
