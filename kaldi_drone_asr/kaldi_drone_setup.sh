#home directory를 수정할 필요 있음. kaldi_drone/data/lm에 text(문장파일), lexicon_raw_nosil.txt(문장에 있는 단어의 발음)

home_dir='/home/yoonseo'

rm -r $home_dir/kaldi_drone/testdata_hires
rm -r $home_dir/kaldi_drone/exp
rm -r $home_dir/kaldi_drone/data/lang_test_tgsmall
rm -r $home_dir/kaldi_drone/data/local
rm -r $home_dir/kaldi_drone/data/lang


cd $home_dir/kaldi_drone/data/lm/
ngram-count -text text -write-vocab vocab -write unigram.feq
ngram-count -vocab vocab -text text -order 5 -write count
ngram-count -vocab vocab -read count -order 5 -lm lm.arpa

cd $home_dir/kaldi/egs/librispeech/s5/
./local/drone_prepare_dict.sh --stage 3 $home_dir/kaldi_drone/data/lm $home_dir/kaldi_drone/data/local/dict
./utils/prepare_lang.sh $home_dir/kaldi_drone/data/local/dict "<UNK>" $home_dir/kaldi_drone/data/local/lang $home_dir/kaldi_drone/data/lang



. cmd.sh
. path.sh
arpa2fst --disambig-symbol=#0 --read-symbol-table=$home_dir/kaldi_drone/data/lang/words.txt $home_dir/kaldi_drone/data/lm/lm.arpa $home_dir/kaldi_drone/data/lang/G.fst



# fit phones to librispeech corpus
cd $home_dir/kaldi_drone/
tar -zxvf 0013_librispeech_v1_extractor.tar.gz
tar -zxvf 0013_librispeech_v1_chain.tar.gz
tar -zxvf 0013_librispeech_v1_lm.tar.gz

rm -rf $home_dir/kaldi_drone/data/lang/phones
rm -rf $home_dir/kaldi_drone/data/lang/phones.txt
cp $home_dir/kaldi_drone/data/lang_test_tgsmall/phones.txt $home_dir/kaldi_drone/data/lang/phones.txt
cp -r $home_dir/kaldi_drone/data/lang_test_tgsmall/phones $home_dir/kaldi_drone/data/lang/phones

rm $home_dir/kaldi_drone/data/lang/L.fst



cd $home_dir/kaldi/egs/librispeech/s5/
./utils/lang/make_lexicon_fst.py $grammar_opts --sil-prob=0.5 --sil-phone="SIL" \
            $home_dir/kaldi_drone/data/local/lang/lexiconp.txt | \
    fstcompile --isymbols=$home_dir/kaldi_drone/data/lang/phones.txt --osymbols=$home_dir/kaldi_drone/data/lang/words.txt \
      --keep_isymbols=false --keep_osymbols=false | \
    fstarcsort --sort_type=olabel > $home_dir/kaldi_drone/data/lang/L.fst

fsttablecompose $home_dir/kaldi_drone/data/lang/L.fst $home_dir/kaldi_drone/data/lang/G.fst > $home_dir/kaldi_drone/data/lang/LG.fst
cp $home_dir/kaldi_drone/data/lang/L.fst $home_dir/kaldi_drone/data/lang/L_disambig.fst
./local/drone_mkgraph.sh $home_dir/kaldi_drone/data/lang $home_dir/kaldi_drone/exp/chain_cleaned/tdnn_1d_sp/ $home_dir/kaldi_drone/exp/graph



# # 이전 버전
# rm -r ~/kaldi_drone/testdata_hires
# rm -r ~/kaldi_drone/exp
# rm -r ~/kaldi_drone/data/lang_test_tgsmall
# rm -r ~/kaldi_drone/data/local
# rm -r ~/kaldi_drone/data/lang


# cd ~/kaldi_drone/data/lm/
# ngram-count -text text -write-vocab vocab -write unigram.feq
# ngram-count -vocab vocab -text text -order 5 -write count
# ngram-count -vocab vocab -read count -order 5 -lm lm.arpa

# cd ~/kaldi/egs/librispeech/s5/
# ./local/drone_prepare_dict.sh --stage 3 ~/kaldi_drone/data/lm ~/kaldi_drone/data/local/dict
# ./utils/prepare_lang.sh ~/kaldi_drone/data/local/dict "<UNK>" ~/kaldi_drone/data/local/lang ~/kaldi_drone/data/lang



# . cmd.sh
# . path.sh
# arpa2fst --disambig-symbol=#0 --read-symbol-table=/home/yoonseo/kaldi_drone/data/lang/words.txt ~/kaldi_drone/data/lm/lm.arpa ~/kaldi_drone/data/lang/G.fst



# # fit phones to librispeech corpus
# cd ~/kaldi_drone/
# tar -zxvf 0013_librispeech_v1_extractor.tar.gz
# tar -zxvf 0013_librispeech_v1_chain.tar.gz
# tar -zxvf 0013_librispeech_v1_lm.tar.gz

# rm -rf ~/kaldi_drone/data/lang/phones
# rm -rf ~/kaldi_drone/data/lang/phones.txt
# cp ~/kaldi_drone/data/lang_test_tgsmall/phones.txt ~/kaldi_drone/data/lang/phones.txt
# cp -r ~/kaldi_drone/data/lang_test_tgsmall/phones ~/kaldi_drone/data/lang/phones

# rm ~/kaldi_drone/data/lang/L.fst



# cd ~/kaldi/egs/librispeech/s5/
# ./utils/lang/make_lexicon_fst.py $grammar_opts --sil-prob=0.5 --sil-phone="SIL" \
#             ~/kaldi_drone/data/local/lang/lexiconp.txt | \
#     fstcompile --isymbols=/home/yoonseo/kaldi_drone/data/lang/phones.txt --osymbols=/home/yoonseo/kaldi_drone/data/lang/words.txt \
#       --keep_isymbols=false --keep_osymbols=false | \
#     fstarcsort --sort_type=olabel > ~/kaldi_drone/data/lang/L.fst

# fsttablecompose ~/kaldi_drone/data/lang/L.fst ~/kaldi_drone/data/lang/G.fst > ~/kaldi_drone/data/lang/LG.fst
# cp ~/kaldi_drone/data/lang/L.fst ~/kaldi_drone/data/lang/L_disambig.fst
# ./local/drone_mkgraph.sh ~/kaldi_drone/data/lang ~/kaldi_drone/exp/chain_cleaned/tdnn_1d_sp/ ~/kaldi_drone/exp/graph
