
# get variables
BIOCONTAINER="${biocontainerName}"
FILEDIR="${additionalFileDirectory}"
COMMAND="${command}"
ARGS="${commandArgs}"

# check to make sure biocontainer name provided
if [ -z "$BIOCONTAINER" ]; then
        echo "No biocontainer name given." >&2
        ${AGAVE_JOB_CALLBACK_FAILURE}
        exit

# find image
IMAGE_STORAGE="/scratch/01114/jfonner/singularity/"
CONTAINER_PATH="$(ls ${IMAGE_STORAGE}quay.io_biocontainers_${BIOCONTAINER}*.img.bz2)"

# check image found
if [ -z "$CONTAINER_PATH" ]; then
	echo "No biocontainer singularity with name $BIOCONTAINER found in image storage." >&2
        ${AGAVE_JOB_CALLBACK_FAILURE}
        exit

# copy image to local directory and unzip
cp $CONTAINER_PATH .
LOCAL_IMAGE="$(ls quay.io_biocontainers_${BIOCONTAINER}*.img.bz2)"
bzip2 -d $LOCAL_IMAGE
LOCAL_IMAGE="$(ls quay.io_biocontainers_${BIOCONTAINER}*.img)"

# run command
if [ -z "$COMMAND" ]; then
	singularity run $LOCAL_IMAGE $ARGS
else
	singularity exec $LOCAL_IMAGE $COMMAND $ARGS
fi

