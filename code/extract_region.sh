 #!usr/bin/env bash
 
 # author: Gaurav Bhatti
 # dependency: data/raw/rrnDB-5.9_16S_rRNA.align
 # input: the target name, which is really the output
 #        data/<region>/rrnDB.align 
 # outputs: data/<region>/rrnDB.align



 target=$1
 region=`echo "$target" | sed -E "s/.*\/(.*)\/.*/\1/"`
 path=`echo "$target" | sed -E "s/(.*\/.*)\/.*/\1/"`

 if [[ "$region" = "v19" ]]
 then
     start=1044
     end=43116    
 elif [[ "$region" = "v4" ]]
 then 
     start=13862
     end=23444
 elif [[ "$region" = "v34" ]]
 then 
     start=6428
     end=23444
 elif [[ "$region" = "v45" ]]
 then 
     start=13862
     end=27659
 else
     echo "FAIL: We don't have the coordinates for $region"
     exit 1
 fi

 echo "region: $region"
 echo "start: $start"
 echo "end: $end"

 mkdir -p $path

 code/mothur/mothur "#pcr.seqs(fasta=data/raw/rrnDB-5.9_16S_rRNA.align,
            start=$start,
            end=$end,
            outputdir=$path);
            filter.seqs(vertical=TRUE)"
 
 # If mother executed successfully, then touch the files that might
 # not have been generated in pcr.seqs because the sequence spanned
 # the desired region's coordinates.

 if [[ $? -eq 0 ]]
 then 
     sed "s/^\.*/-/" $path/rrnDB-5.9_16S_rRNA.pcr.filter.fasta > $path/rrnDB-5.9_16S_rRNA.pcr.filter.temp.fasta
     touch $path/rrnDB-5.9_16S_rRNA.bad.accnos
     touch $path/rrnDB-5.9_16S_rRNA.scrap.pcr.align
 else
     echo "FAIL: mothur ran into a problem"
     exit 1
 fi

 # clean up the file names
 mv $path/rrnDB-5.9_16S_rRNA.pcr.filter.temp.fasta $target
 mv $path/rrnDB-5.9_16S_rRNA.bad.accnos $path/rrnDB.bad.accnos
 
 # garbage collection
 rm $path/rrnDB-5.9_16S_rRNA.pcr.align
 rm $path/rrnDB-5.9_16S_rRNA.pcr.filter.fasta  
 rm $path/rrnDB-5.9_16S_rRNA.scrap.pcr.align
 rm $path/rrnDB-5.filter
 
