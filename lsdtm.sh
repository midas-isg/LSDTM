#!/bin/sh

base_dir=$(dirname "$0")
population_type="synthetic_population_id"
model="fred/fred-phdl2.12.0-isg1.0"
ecosystem="fred_populations/spew2synthia-1.2.0"

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
	echo "    Model to run population on (default is fred/fred-phdl2.12.0-isg1.0)"
	echo
	echo "-e, --ecosystem"
        echo "    Ecosystem containing population (default is fred_populations/spew2synthia-1.2.0)"
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
	-e | --ecosystem )         shift
                                   ecosystem=$1
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
	
	module load $ecosystem
	$base_dir/generate_params.sh $population_id $population_type
	module unload $ecosystem
	
	$base_dir/run_dtm.sh $model $ecosystem
else
	usage
	$(>&2 echo "Error: Failed to provide Synthetic Population ID")
	$(>&2 echo "Aborted")
fi

