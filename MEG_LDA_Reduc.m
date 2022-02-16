
% Input Parameters - use defaults for now - Motor Img Cal, Subj 9
definput = cell(10,1);
definput(:) = [{'1'};{'9'};{'8.5'};{'12'};{'0.5'};{'3'};{'0.5'};{'0'};{'2'};{'50'}];
answers = meg_answer(definput);

srate = 1000;

 % stud{1} -> MIcal; stud{2} -> MIcont
[blocks, stud, subj] = meg_blocks(answers);


% Delete unused channels
% blocks(1).meg(:,[4 6 7 11 15 16 20 23]) = [];
% blocks(2).meg(:,[4 6 7 11 15 16 20 23]) = [];

% Extract labels from MEG data for movement task
[labels, meg] = meg_labels(answers);

meg( all(~meg,2), : ) = [];

meg = meg*10^12;

% Find Onset and Offset Data of Tasks
[RestOnset, MoveOnset, RestOffset, MoveOffset] = meg_offsetdata(blocks);

% REARRANGE THE CHANNEL NUMBERS TO GO FROM TOP-LEFT TO BOTTOM-RIGHT ON
% SCALP MAP
% [meg] = meg_chanarrange(meg);

tw = 500;
shift = 100;
fs = 1000;
nfft = 1028;
freq = 0:fs/nfft:fs/2;
chans = size(meg,1);
trials = int64((size(meg, 2) - tw)/shift + 1);

% Initialize Variables
[meg_tw, Fmeg, meg_f, meg_fft_singleTW, x_abs, x_pow, x_pow_str, feat, alpha, beta, w, freq_val, freq_width, PLV, d, B, I, d_sort, d_s, PLV_Rest_I, PLV_Move_I] =meg_initvars(answers, meg, fs,nfft, freq, chans, trials);

[meg_tw, Fmeg, PLV, PLV_Rest_I, PLV_Move_I, PLV_cut, row, col] = meg_PLV(meg, w, labels, trials, shift, tw, srate, freq_val, freq_width, Fmeg);

top_features = 10;

[PLV_Mahal_Sort, PLV_Mahal_Coord, PLV_Diff_Coord, PLV_Diff_Sort, trials_compared] = meg_PLVfeatures(top_features, PLV_Move_I, PLV_Rest_I, PLV_cut, row, col);

[Mahal_Vec, Class_Vec] = meg_featuresSorted(trials_compared, top_features, PLV_Mahal_Sort, PLV_Mahal_Coord);




