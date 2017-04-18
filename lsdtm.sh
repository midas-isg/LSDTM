#!/bin/sh

base_dir=$(dirname "$0")
population_type="synthetic_population_id"

big_populations=("spew_1.2.0_chn", "spew_1.2.0_ind", "spew_1.2.0_usa")

function usage
{
	echo "usage: lsdtm.sh [[[-p Synthetic Population ID] [-o Output Directory]] | [-h Help]]"
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
	-f | --fips )              shift
				   population_type="fips"
				   ;;
	-c | --city )              shift
				   if [ $population_type != "fips" ]; then
				  	 population_type="city"
				   fi
				   ;;
	-C | --county )            shift
				   if [ $population_type != "city" ] && [ $population_type != "fips" ]; then
				   	population_type="county"
				   fi
				   ;;
	-s | --state )             shift
				   if [ $population_type == "synthetic_population_id" ]; then
				   	population_type="state"
				   fi
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

if [ ! -z $population_id ]; then
	if [ ! -z $output_directory ]; then
		if [ ! -d $output_directory ]; then
			mkdir $output_directory
		fi
		
		cd $output_directory
	fi
	
	if [ $population_type != "synthetic_population_id" ]; then
		echo "Setting $population_id as $population_type"
	fi
	
	use_big=false
	
	for i in $big_populations; do
		if [ $population_id  == i ]; then
			use_big=true
			break
		fi
	done
	
	if [ ! use_big ]; then
		qsub -v SYNTHETIC_POPULATION_ID="$population_id",POPULATION_TYPE="$population_type" $base_dir/spew2synthia_fred.pbs
	else
		qsub -v SYNTHETIC_POPULATION_ID="$population_id",POPULATION_TYPE="$population_type" $base_dir/spew2synthia_fred_big.pbs
	fi
else
	usage
	$(>&2 echo "Failed to provide Synthetic Population ID")
	$(>&2 echo "Aborted")
fi

