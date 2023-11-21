#!/usr/bin/env bash


mfccdir=mfcc
stage=1

. ./cmd.sh
. ./path.sh
. parse_options.sh

# you might not want to do this for interactive shells.
set -e
clear


if [ $stage -le 1 ]; then
  echo "----------------Prapring lang folder----------------"
  rm -r data/local/lang_tmp
  utils/prepare_lang.sh data/local/dict_2l_MST \
   "<unk>" data/local/lang_tmp data/lang_min
fi

if [ $stage -le 2 ]; then
  # Create ConstArpaLm format language model for full 3-gram and 4-gram LMs
  echo "----------------formatting lms and ConstArpalms----------------"
  local/prepare_lms.sh  

  utils/build_const_arpa_lm.sh data/local/lms/lmExtraTextMSTrainTextLarge.arpa.gz \
    data/lang_min data/lang_test_lmExtraTextMSTrainTextLarge
 fi
exit

if [ $stage -le 3 ]; then
  echo "----------------Extracting MFCCs----------------"
  for part in train_synthetic test_msr_modified; do
    utils/fix_data_dir.sh data/${part}
		utils/validate_data_dir.sh --no-feats data/${part}
    
    steps/make_mfcc.sh --cmd "$train_cmd" --nj 40 data/$part exp/make_mfcc/$part $mfccdir
    steps/compute_cmvn_stats.sh data/$part exp/make_mfcc/$part $mfccdir
  done
fi

if [ $stage -le 4 ]; then
  # train a monophone system
  echo "----------------Training monophone system----------------"
  steps/train_mono.sh --boost-silence 1.25 --nj 20 --cmd "$train_cmd" \
                      data/train_synthetic data/lang exp/mono
fi

if [ $stage -le 5 ]; then
  echo "----------------Aligning using monophone system----------------"
  steps/align_si.sh --boost-silence 1.25 --nj 10 --cmd "$train_cmd" \
                    data/train_synthetic data/lang exp/mono exp/mono_ali
fi

if [ $stage -le 6 ]; then
  # train a first delta + delta-delta triphone system
  echo "----------------Training delta + delta-delta triphone system----------------"
  steps/train_deltas.sh --boost-silence 1.25 --cmd "$train_cmd" \
                        2000 10000 data/train_synthetic data/lang exp/mono_ali exp/tri1
fi

if [ $stage -le 7 ]; then
  echo "----------------Aligning using delta + delta-delta triphone system----------------"
  steps/align_si.sh --nj 10 --cmd "$train_cmd" \
                    data/train_synthetic data/lang exp/tri1 exp/tri1_ali
fi

if [ $stage -le 8 ]; then
  # train an LDA+MLLT system.
  echo "----------------Training LDA+MLLT system----------------"
  steps/train_lda_mllt.sh --cmd "$train_cmd" \
                          --splice-opts "--left-context=3 --right-context=3" 2500 15000 \
                          data/train_synthetic data/lang exp/tri1_ali exp/tri2
fi

if [ $stage -le 9 ]; then
echo "----------------Aligning using LDA+MLLT system----------------"
  steps/align_si.sh  --nj 10 --cmd "$train_cmd" --use-graphs true \
                     data/train_synthetic data/lang exp/tri2 exp/tri2_ali
fi

if [ $stage -le 10 ]; then
  # Train tri3b, which is LDA+MLLT+SAT on 10k utts
  echo "----------------Training LDA+MLLT+SAT system----------------"
  steps/train_sat.sh --cmd "$train_cmd" 2500 15000 \
                     data/train_synthetic data/lang exp/tri2_ali exp/tri3
fi

# if [ $stage -le 11 ]; then
#   echo "----------------Decoding using LDA+MLLT+SAT system----------------"
#   utils/mkgraph.sh data/lang_test_lmSmall \
#                    exp/tri3 exp/tri3/graph_lmSmall
#   for test in test_msr; do
#       steps/decode_fmllr.sh --nj 20 --cmd "$decode_cmd" \
#                             exp/tri3/graph_lmSmall data/$test exp/tri3/decode_lmSmall_$test
#       # steps/lmrescore.sh --cmd "$decode_cmd" data/lang_test_{lmSmall,lmLarge} \
#       #                    data/$test exp/tri3/decode_{lmSmall,lmLarge}_$test
#       steps/lmrescore_const_arpa.sh \
#         --cmd "$decode_cmd" data/lang_test_{lmSmall,lmLarge} \
#         data/$test exp/tri3/decode_{lmSmall,lmLarge}_$test
#       # steps/lmrescore_const_arpa.sh \
#       #   --cmd "$decode_cmd" data/lang_test_{lmSmall,fglarge} \
#       #   data/$test exp/tri3/decode_{lmSmall,fglarge}_$test
#   done

# fi


if [ $stage -le 12 ]; then
echo "----------------Training CNN TDNN system----------------" 
  tdnn_stage=0
	tdnn_train_iter=-10 #default=-10
	gmm=tri3
	nnet3_affix=_fmllr
	affix=cnn
	tree_affix=7000
  local/chain/run_cnn_tdnn.sh --stage $tdnn_stage --train_stage $tdnn_train_iter \
		--train_set train_synthetic --gmm $gmm \
		--nnet3_affix $nnet3_affix \
		--affix $affix \
		--tree_affix $tree_affix || exit 1;
fi


