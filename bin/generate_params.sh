#!/usr/bin/sh

if [ ! -z "$1" ]; then
	population=$1
	
	echo "synthetic_population_directory = ${FRED_POPULATIONS}" > ${PWD}/params
	
	if [ $2 == "synthetic_population_id" ]  && [ -d "${FRED_POPULATIONS}/$1" ]; then
		echo "synthetic_population_id = $population" >> ${PWD}/params
	else
		population_type=$2
		echo "$population_type = $population" >> ${PWD}/params
	fi
	
	echo "verbose = 0" >> ${PWD}/params
	
	#start_date
	#seed
	#outdir
	
	#quality_control
	#report_age_of_infection
	#report_place_of_infection
	#report_generation_time
	#report_serial_interval
	#report_incidence_by_county
	#track_infection_events
	
	#enable_visualization_layer
	#household_visualization_mode
	#census_tract_visualization_mode
	#visualization_grid_size
	
	#debug

	echo "Successfully created params."
	echo
else
	$(>&2 echo "$1 not found. Try double checking the SYNTHETIC_POPULATION_ID.")
	$(>&2 echo "Usage: generate_params.sh SYNTHETIC_POPULATION_ID")
	$(>&2 echo)
fi

