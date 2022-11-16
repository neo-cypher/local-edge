# Clones and builds repositories needed to run storj services

### Prerequisites

1. Golang v1.18
2. NodeJS and NPM
3. You must be a memeber of the storj organization on Github.
4. SSH or GPG installed and configured for your storj github user.
5. Make sure go/bin is in your path.

## clone-repos.sh

The clone repo script clones the necessary repositories and likely a few unnecesary repositories needed to run storj services locally. It accepts a few optional arguments so that your environment is configured for your task. When setting the -e option it sets the environment to development. This option clones the repos and installs the gerrit support scripts so that you can pull your gerrit patchset into the runtime environment.

Keep in mind that if the script encounters any folder with the same name as the repo it will skip that repo. This assumption allows you to have existing code checked out and pulls just the requirements for Edge Services.

Another optional argument is the -c switch, this switch cleans your environment. Essentially it cleans any compiled binaries from your $GOBIN as well as the modules inclusive to your go.mod and go.sum implementation. I don’t see this being needed but thought it could be during development.


## build-web.sh

Builds the following Web User Interfaces and the WASM:

1. Satellite
2. Storage Node
3. Multi-node Dashboard

> When building the Web Interfaces we will attempt to use any cached pacakges and have supressed logging in order to tidy up the interface. 

## clean-project.sh

The clean-project.sh script will delete the repositories that we pulled in the clone-repos.sh shell script. It should also delete the compiled binaries from the system as well as removing the dependancies. This will allow you to clean your environment in the event you are seeing an issue that hasn't been reproducible .
