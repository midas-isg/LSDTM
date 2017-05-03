#!/bin/sh

base_dir=$(dirname "$0")
big_populations[0]="spew_1.2.0_chn"
big_populations[1]="spew_1.2.0_ind"
big_populations[2]="spew_1.2.0_usa"

population_id=""
model="fred/fred-phdl2.12.0-isg1.0"
ecosystem="fred_populations/spew2synthia-1.2.0"

if [ ! -z $1 ]; then
        model=$1
fi

if [ ! -z $2 ]; then
        ecosystem=$2
fi

if [ -e params ]; then
	line=$(grep synthetic_population_id params)
	
	if [ ! -z "$line"  ]; then
		for (( i=0; i<${#line}; i++ )); do
			if [ "${line:$i:1}" = "=" ]; then
				i=$((i + 2))
				population_id="${line:$i}"
				break
			fi
		done
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
		qsub -N "$model.$ecosystem.big" -v MODEL="$model" $base_dir/spew2synthia_fred_big.pbs
		echo
	else
		qsub -N "$model.$ecosystem" -v MODEL="$model" $base_dir/spew2synthia_fred.pbs
		echo
	fi
else
	$(>&2 echo "Error: params file not found")
	$(>&2 echo "Aborted")
fi

