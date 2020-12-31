    pipeline {
        agent {
            docker {
                image 'selvanponraj/multiprojects:1.0'
                args '-v /root/.m2:/root/.m2 --network=host'
            }
        }
        
        stages {
            stage('Checkout') {
                steps {
                script{
                        cleanWs()
                        checkout([$class: 'GitSCM', 
                                    branches: [[name: 'origin/master']],
                                    doGenerateSubmoduleConfigurations: false,  extensions: [[$class: 'LocalBranch', localBranch: 'master']], 
                                    submoduleCfg: [], 
                                    userRemoteConfigs: [[credentialsId: 'git_hub_credential_key', url: 'git@github.com:selvanponraj/multi_projects.git']]])
                    
                        env.LAST_GREEN_TAG = sh(returnStdout: true, script: "git tag -l last_green_master").trim()
                    
                        if ("$LAST_GREEN_TAG" == "") {
                            env.CHANGED = "ALL"
                            echo "Going to build $CHANGED modules, can't find tag last_green_master in gitlab"
                        } else {
                            env.last_commit = sh(returnStdout: true, script: "git rev-list -n 1 HEAD").trim()
                            env.CHANGED = sh(returnStdout: true, script: 'git show --perl-regexp "--author=^((?!jenkins).*)$" --diff-filter=MTA --pretty=format: --name-only last_green_master...${last_commit}').trim()
                            echo "$CHANGED"
                            def CHANGED_LIST = CHANGED.tokenize().toSet()
                            echo "changes detected in : $CHANGED_LIST"
                            def difflist = []

                            def diffset = CHANGED_LIST
                            echo "DIFFSET : $diffset"
                            diffset.each { line ->
                                if (line.tokenize('/').size() <= 1) {
                                difflist << line
                                } else {
                                def newline = line.tokenize('/')[0..<1]
                                difflist << newline.join('/') + '/'
                                }
                            echo "DIFFLIST : $difflist"
                            
                            diffset = difflist.toSet()
                            }
                            echo "changes detected diffset : $diffset"
                            def CHANGED = diffset
                            echo "changes detected in CHANGED : $CHANGED"
                            def CHANGED_LIST_NEW = diffset.join(",")
                            echo "changes detected in NEW : $CHANGED_LIST_NEW"
                        }
                    }
                    
                }
            }
            stage('Test Java'){
                when {
                expression { ["simple-java-maven-app/", "ALL"].any { CHANGED.contains(it) }}
                }
                steps{
                    dir('simple-java-maven-app'){
                        script{
                        sh 'mvn --version'
                        sh 'pwd'
                        sh 'ls -lrt'
                        sh 'mvn clean install'
                    }
                    }
                    
                }
            }
            

            stage('Test Python'){
                when {
                expression { ["python-test-calculator/", "ALL"].any { CHANGED.contains(it) }}
                }
                steps{
                    dir('python-test-calculator'){
                        script{
                        sh 'python3 --version'
                        sh 'pip3 install -r requirements.txt'
                        sh 'python3 setup.py install'
                    }
                    }
                    
                }
            }

            stage ('push tag') {
                steps {
                        sshagent(['git_hub_credential_key']) {
                            script {
                                sh 'pwd'
                                sh 'ls -la'
                                sh 'git tag -f last_green_master'
                                sh 'git push -f origin last_green_master'
                            }
                         }
                }
                
            }
            
        }
    }