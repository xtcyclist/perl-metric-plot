use GD::Graph::linespoints;
#use GD::graph3d::hbars;
#require 'save.pl';
#read data

#$time=$ARGV[1];
#$time_2=$ARGV[2];

open (perf_file, $ARGV[0]);
open (OUTFILE, '>>'."info_".$ARGV[3].".txt");
open (DATAFILE, ">>data.txt");

open (IOFILE, ">>io.txt");
open (READFILE, ">>read.txt");
open (WRITEFILE, ">>write.txt");

open (OUTPUT, '>>'."output.txt");

$count_down=0;
$base1;
$base2;
$base3;
$base4;
$id=0;
while (<perf_file>)
{
	chomp;
	$string=$_;
	if ($_ =~ /SGT/)
	{
		$id+=1;
		$string=$_;
		@array=split (' ',$string);
		$time=$array[3]; #acquire the starting time
		$string=<perf_file>;
		#@array=split (':',$string);
		$time_2=$string/1000;#$array[0]*60+$array[1];
		print OUTPUT $time_2."\t";
		open (file, $ARGV[1]);
		@cpu;
		@mem;
		$count=0;
		$#cpu=0;
		while (<file>)
		{
			chomp;
			if ($_ =~ /\Q$time\E/) {
				while (<file>)
				{
					chomp;
					if ($_ =~ /mserver5/)
					{
						@array=split (" ",$_);
						$cpu[$count]=$array[8];
						$mem[$count]=$array[9];
						$count+=1;
					}
					if ($count>=$time_2+1)
					{
						goto IO;
					}
				}
			}
		}
IO:
		@tps;
		@read;
		@write;
		open (io_file, $ARGV[2]);
		while (<io_file>)
		{
			chomp;
			if ($_ =~ /\Q$time\E/) 
			{
				#print "Hello   ".$_."\n";
				$string=<io_file>;
				$string=<io_file>;
				$string=<io_file>;
				$string=<io_file>;
				$string=<io_file>;
				$string=<io_file>;
				#print $string."\n";
				for ($i=0; $i<$time_2+1; $i=$i+1) {
					@array=split (" ",$string);
					#print $array[0]."\n";
					$tps[$i]=$array[1];
					$read[$i]=$array[2];
					$write[$i]=$array[3];
					
					print IOFILE $tps[$i].",";
					print READFILE $read[$i].",";
					print WRITEFILE $write[$i].",";
					
					$string=<io_file>;
					$string=<io_file>;
					$string=<io_file>;
					$string=<io_file>;
					$string=<io_file>;
					$string=<io_file>;
					$string=<io_file>;
					$string=<io_file>;
				}
				goto DRAW;
			}
			print IOFILE "\n";
			print READFILE "\n";
			print WRITEFILE "\n";
		}
DRAW:
		@data_0;#count
                @data_1;#IOWAIT
                @data_2;#cpu
                @data_3;
                @data_4;
                @data_5;
                $#data_0=0;
                $#data_2=0;
		$sumtps=0;
		$sumr=0;
		$sumw=0;
		$summem=0;
                for ($i =0; $i <$#cpu; $i=$i+1 )
                {
                        $data_0[$i]=$i;
                        $data_1[$i]=$mem[$i];
                        $data_2[$i]=$cpu[$i];
                        $data_3[$i]=$tps[$i];
                        $data_4[$i]=$read[$i];
                        $data_5[$i]=$write[$i];
						$sumtps+=$tps[$i];
						$sumr+=$read[$i];
						$sumw+=$write[$i];
						$summem+=$mem[$i];
		}
		print OUTPUT $sumtps."\t".$sumr."\t".$sumw."\t".$summem."\n";
                my $data = GD::Graph::Data->new([
                        [@data_0],
                        [@data_1],
                        [@data_2],
                        #[@data_3],
                        #[@data_4],
                        #[@data_5]
                ]) or die GD::Graph::Data->error;
                #@file_name_array=$ARGV[0]." ".$ARGV[1];
                $file_name='>'."query_".$id.".png";
                #'>'.@file_name_array.".png";
                #draw figures
                my $my_graph = GD::Graph::linespoints->new(2048,768);
                $my_graph->set (
                x_tick_number=>'auto',
                x_label => 'time',
                #y_label => 'CPU',
                title => 'CPU versus TPS'.$name,
                borderclrs => $my_graph->{dclrs},
                bar_spacing =>2,
                transparent =>0,
                two_axes=>1,
                use_axis => [1,2],
                y_tick_number=> 10,
                y1_label=>'MEM',
                y1_max_value=>100,
                y1_min_value=>0,
                y2_label=>'CPU',
                y2_max_value=>1200,
                y2_min_value=>0
                ) or die $my_graph->error;
                $my_graph->set_legend( qw(MEM CPU_util));
                $my_graph->set( dclrs => [ qw(blue red) ] );
                my $gd = $my_graph->plot($data) or die $my_graph->error;
		open(IMG, $file_name) or die $!;
		binmode IMG;
		print IMG $gd->png;
	}
}

