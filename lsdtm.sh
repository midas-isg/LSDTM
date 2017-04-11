#!/bin/sh

function usage
{
	echo "usage: lsdtm.sh [[[-p Synthetic Population ID] [-o Output Directory]] | [-h Help]]"
	echo "    This script will call a PSC PBS request to run FRED on the provided Synthetic Population ID."
	echo
	echo "-p, --population"
	echo "    Synthetic Population ID"
	echo
	echo "-o, --output_directory"
	echo "    Directory where the output will be generated"
	echo
	echo "-h, --help"
	echo "    Display this help information"
	echo
}

base_dir=$(dirname "$0")

while [ "$1" != "" ]; do
    case $1 in
        -p | --population )        shift
                                   population_id=$1
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
	
	qsub -v SYNTHETIC_POPULATION_ID="$population_id" $base_dir/spew2synthia_fred.pbs 
else
	usage
	$(>&2 echo "Failed to provide Synthetic Population ID")
	$(>&2 echo "Aborted")
fi

