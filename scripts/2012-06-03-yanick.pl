die@$_ for
sort{@$a-@$b}map{$i=$_;[(Albus,Burdock,Carlotta,Daisy,Elfrida,
Falco)[grep$i&2**$_,0..5]]}grep{$x=$_;$x|=$f{$_}x($_==$_&$x)for
(%f=(1,6,4,9,16,7,32,12,12,50,3,8))x6;63==$x}1..63
