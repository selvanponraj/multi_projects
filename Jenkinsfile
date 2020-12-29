pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
            args '-v /root/.m2:/root/.m2'
        }
    }
    stages {
		stage("Checkout") {
		  steps {
		    script {
		      cleanWs()
		  	  git branch: 'master', url: "git@<github>.git", credentialsId: 'git_hub_credential'
		  	  env.LAST_GREEN_TAG = sh(returnStdout: true, script: "git tag -l last_green_feature").trim()

		  	  if ("$LAST_GREEN_TAG" == "[]") {
                  CHANGED = "ALL"
                  echo "Going to build $CHANGED modules, can't find tag last_green_feature in gitlab"
              } else {
                  env.last_commit = sh(returnStdout: true, script: "git rev-list -n 1").trim()
                  env.CHANGED = sh(returnStdout: true, script: "git show --perl-regexp '--author=^((?!jenkins).*)$' --diff-filter=MTA --pretty=format: --name-only last_green_feature...${last_commit}").trim()

                  echo "$CHANGED"
                  CHANGED_LIST = CHANGED.join(",")
                  echo "changes detected in : $CHANGED_LIST"

                  
              }

		    }
		  }
		  

		}
	}
}