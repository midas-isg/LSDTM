#!/bin/sh

base_dir=$(dirname "$0")
population_type="synthetic_population_id"
model="fred/fred-phdl2.12.0-isg1.0"

big_populations[0]="spew_1.2.0_chn"
big_populations[1]="spew_1.2.0_ind"
big_populations[2]="spew_1.2.0_usa"

function usage
{
	echo "usage: lsdtm.sh [[[-p Synthetic Population ID] [-f|-c|-C|-s] [-o Output Directory]] | [-h Help]]"
	echo "    This script will call a PSC PBS request to run FRED on the provided Synthetic Population ID."
	echo
	echo "-p, --population"
	echo "    Synthetic Population ID"
	echo
	echo "-f, --fips"
	echo "    Override to use FIPS code as Synthetic Population ID"
	echo
	echo "-c, --city"
	echo "    Override to use city name as Synthetic Population ID"
	echo
	echo "-C, --county"
	echo "    Override to use county name as Synthetic Population ID"
	echo
	echo "-s, --state"
	echo "    Override to use state name as Synthetic Population ID"	
	echo
	echo "-m, --model"
	echo "    Model to run population on (default is fred-phdl2.12.0-isg1.0)"
	echo
	echo "-o, --output_directory"
	echo "    Directory where the output will be generated"
	echo
	echo "-h, --help"
	echo "    Display this help information"
	echo
}

while [ "$1" != "" ]; do
    case $1 in
        -p | --population )        shift
                                   population_id=$1
                                   ;;
	-f | --fips )              population_type="fips"
				   ;;
	-c | --city )              if [ "$population_type" != "fips" ]; then
				  	 population_type="city"
				   fi
				   ;;
	-C | --county )            if [ "$population_type" != "city" ] && [ $population_type != "fips" ]; then
				   	population_type="county"
				   fi
				   ;;
	-s | --state )             if [ "$population_type" == "synthetic_population_id" ]; then
				   	population_type="state"
				   fi
				   ;;
        -m | --model )		   shift
				   model=$1
				   ;;
        -o | --output_directory )  shift
                                   output_directory=$1
                                   ;;
        -h | --help )              usage
                                   exit
                                   ;;
        * )                        usage
                                   exit 1
    esac
    shift
done

if [ ! -z "$population_id" ]; then
	if [ ! -z "$output_directory" ]; then
		if [ ! -d "$output_directory" ]; then
			mkdir $output_directory
		fi
		
		cd $output_directory
	fi
	
	if [ "$population_type" != "synthetic_population_id" ]; then
		echo "Setting $population_id as $population_type"
	fi
	
	use_big=false
	
	for big_population in ${big_populations[@]}; do
		if [ "$population_id" = "$big_population" ]; then
			echo "Large population detected; requesting more memory"
			use_big=true
			break
		fi
	done
	
	if [ "$use_big" = true ]; then
		qsub -v SYNTHETIC_POPULATION_ID="$population_id",POPULATION_TYPE="$population_type",MODEL="$model" $base_dir/spew2synthia_fred_big.pbs
	else
		qsub -v SYNTHETIC_POPULATION_ID="$population_id",POPULATION_TYPE="$population_type",MODEL="$model" $base_dir/spew2synthia_fred.pbs
	fi
else
	usage
	$(>&2 echo "Failed to provide Synthetic Population ID")
	$(>&2 echo "Aborted")
fi

