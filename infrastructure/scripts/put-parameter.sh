#! /bin/bash

function help() {
  echo """
    The following parameter are required to execute the scripts. You can set them as environment variables or
    pass them as arguments when executing the scripts. When passing the variables as arguments the scripts has
    been implemented to accept the arguments from most required (Most likely to change) to less required (Less likely to change).
    PARAMETER_KEY = This is the key that describe the parameter to be stored;
    PARAMETER_VALUE = This is the value of the parameter to be stored;
    ENVIRONMENT_NAME = This is the environment for the the parameter is to be used for e.g develop, staging, production
    PROJECT_INITIAL = This is the initial of the project or any how you like to identify the project the parameter is associated with
    PARAMETER_TYPE = This let you choose whether to save the parameter as Plain Text or SecureString. (If not set defualt to SecureString)
    OVERWRITE_PARAMETER = Control whether to overwrite a parameter that was already stored
  """
}

if [ $1 == '--help' ] || [ $1 == '-h' ]; then
  help; exit 1
fi

if [ ! -z $1 ]; then
  export PARAMETER_KEY=$1
elif [ -z $PARAMETER_KEY ]; then
  help; exit 2;
fi

if [ ! -z $2 ]; then
  export PARAMETER_VALUE=$2
elif [ -z $PARAMETER_VALUE ]; then
  help; exit 2;
fi

if [ ! -z $3 ]; then
  export ENVIRONMENT_NAME=$3
elif [ -z $ENVIRONMENT_NAME ]; then
  help; exit 2;
fi

if [ ! -z $4 ]; then
  export PROJECT_INITIAL=$4
elif [ -z $PROJECT_INITIAL ]; then
  help; exit 2;
fi

if [ ! -z $5 ]; then
  export PARAMETER_TYPE=$5
elif [ -z $PARAMETER_TYPE ]; then
  export PARAMETER_TYPE=SecureString
fi

export OVERWRITE_PARAM='--no-overwrite'
if [ ! -z $6 ]; then
  if [ $6 == "yes" ] || [ $6 == true ] || [ $6 == "1" ]; then
    export OVERWRITE_PARAM='--overwrite'
  fi
elif [ ! -z $OVERWRITE_PARAMETER ]; then
  if [ $OVERWRITE_PARAMETER == "yes" ] || [ $OVERWRITE_PARAMETER == true ] || [ $OVERWRITE_PARAMETER == 1 ]; then
    export OVERWRITE_PARAM='--overwrite'
  fi
elif [ -z $OVERWRITE_PARAMETER ]; then
  export OVERWRITE_PARAM='--no-overwrite'
fi

export PARAMETER_NAME=${PROJECT_INITIAL}-${ENVIRONMENT_NAME}-${PARAMETER_KEY}
aws ssm put-parameter --name ${PARAMETER_NAME} --value ${PARAMETER_VALUE} --type ${PARAMETER_TYPE} ${OVERWRITE_PARAM}
