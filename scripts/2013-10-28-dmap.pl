
my %hash = (
    Level1_1 => {
        Level2_1 => "val1",
        Level2_2 => {
            Level3_1 => "val2",
            Level3_2 => "val1",
            Level3_3 => "val3",
        },
        Level2_3 => "val3",
    },
    Level1_2 => {
        Level2_1 => "val1",
        Level2_2 => {
            Level3_1 => "val1",
            Level3_2 => "val2",
            Level3_3 => "val3",
        },
        Level2_3 => "val3",
    },
    Level1_3 => {
        Level2_1 => "val1",
        Level2_2 => "val2",
        Level2_3 => "val3",
    }
);


my %result = (
    Level1_1 => {Level2_2 => {Level3_1 => "val2"}},
    Level1_2 => {Level2_2 => {Level3_2 => "val2"}},
    Level1_3 => {Level2_2 => "val2"}
);

use Data::DPath 'dpath';
use Data::Dump 'pp';

pp \%hash ~~ dpath('//*[ value eq "val2" ]');
