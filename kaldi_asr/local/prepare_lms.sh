#!/bin/bash
[ -f path.sh ] && . ./path.sh

lms="lmCombinedSmall lmCombinedLarge"
lms_path=data/local/lms
lang=data/lang

for lm in $lms;do
echo ================== $lm ==================
    lm_tmp_folder=data/lang_test_$lm
    mkdir -p $lm_tmp_folder
    cp -r $lang/* $lm_tmp_folder/
    gunzip -c $lms_path/${lm}.arpa.gz | \
    arpa2fst --disambig-symbol=#0 \
             --read-symbol-table=$lm_tmp_folder/words.txt - $lm_tmp_folder/G.fst
  utils/validate_lang.pl --skip-determinization-check $lm_tmp_folder || exit 1;

done