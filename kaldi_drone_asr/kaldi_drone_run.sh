

home_dir='/home/yoonseo'
src_dir=$1


rm $home_dir/kaldi_drone/one_testdata/wav.scp
echo "1 $src_dir" > $home_dir/kaldi_drone/one_testdata/wav.scp


cd $home_dir/kaldi/egs/librispeech/s5/

./utils/copy_data_dir.sh $home_dir/kaldi_drone/one_testdata/ $home_dir/kaldi_drone/testdata_hires
./utils/fix_data_dir.sh $home_dir/kaldi_drone/testdata_hires/
./steps/make_mfcc.sh --nj 1 --mfcc-config conf/mfcc_hires.conf --cmd run.pl $home_dir/kaldi_drone/testdata_hires/
./steps/compute_cmvn_stats.sh $home_dir/kaldi_drone/testdata_hires/
./utils/fix_data_dir.sh $home_dir/kaldi_drone/testdata_hires/
./steps/online/nnet2/extract_ivectors_online.sh --cmd run.pl --nj 1 $home_dir/kaldi_drone/testdata_hires/ $home_dir/kaldi_drone/exp/nnet3_cleaned/extractor/ $home_dir/kaldi_drone/exp/nnet3_cleaned/ivector_testdata_hires

./steps/nnet3/decode.sh --acwt 1.0 --post-decode-acwt 10.0 --nj 1 --cmd run.pl --online-ivector-dir $home_dir/kaldi_drone/exp/nnet3_cleaned/ivector_testdata_hires/ $home_dir/kaldi_drone/exp/graph/ $home_dir/kaldi_drone/testdata_hires/ $home_dir/kaldi_drone/exp/chain_cleaned/tdnn_1d_sp/decode
cat $home_dir/kaldi_drone/exp/chain_cleaned/tdnn_1d_sp/decode/log/decode.1.log | grep ^[1-9] 

cd $home_dir

# cd $home_dir/kaldi/egs/librispeech/s5/
# ./utils/copy_data_dir.sh ~/kaldi_drone/one_testdata/ ~/kaldi_drone/testdata_hires
# ./utils/fix_data_dir.sh ~/kaldi_drone/testdata_hires/
# ./steps/make_mfcc.sh --nj 1 --mfcc-config conf/mfcc_hires.conf --cmd run.pl ~/kaldi_drone/testdata_hires/
# ./steps/compute_cmvn_stats.sh ~/kaldi_drone/testdata_hires/
# ./utils/fix_data_dir.sh ~/kaldi_drone/testdata_hires/
# ./steps/online/nnet2/extract_ivectors_online.sh --cmd run.pl --nj 1 ~/kaldi_drone/testdata_hires/ ~/kaldi_drone/exp/nnet3_cleaned/extractor/ ~/kaldi_drone/exp/nnet3_cleaned/ivector_testdata_hires
# ./steps/nnet3/decode.sh --acwt 1.0 --post-decode-acwt 10.0 --nj 1 --cmd run.pl --online-ivector-dir ~/kaldi_drone/exp/nnet3_cleaned/ivector_testdata_hires/ ~/kaldi_drone/exp/graph/ ~/kaldi_drone/testdata_hires/ ~/kaldi_drone/exp/chain_cleaned/tdnn_1d_sp/decode
# cat ~/kaldi_drone/exp/chain_cleaned/tdnn_1d_sp/decode/log/decode.1.log | grep ^[1-9] 
