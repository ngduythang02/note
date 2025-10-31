pipeline {
    agent {
        label 'lab-server'
    }
    environment {
        appUser = "shoeshop"
        appName = "shoe-ShoppingCart"
        appVersion = "0.0.1-SNAPSHOT"
        appType = "jar"
        processName = "${appName}-${appVersion}.${appType}"
        folderDeploy = "/datas/${appUser}"
        buildScript = "mvn clean install -DskipTests=True"
        copyScript = "sudo cp target/${processName} ${folderDeploy}"
        permsScript = "sudo chown -R ${appUser}: ${folderDeploy}"
        killScript = "sudo kill -9 \$(ps -ef | grep ${processName} | grep -v grep | awk '{print \$2}')"
        //killScript = "sudo pkill -f ${processName}"
        runScript = 'sudo su ${appUser} -c "cd ${folderDeploy}; java -jar ${processName} > nohup.out 2>&1 &"'
    }
    stages {
        stage('Info') {
            steps {
                echo 'Info'
                sh(script: """ whoami;pwd;ls -la """, label: "first stage")
            }
        }
        stage('build') {
            steps {
                echo 'build'
                sh(script: """ ${buildScript} """, label: "build with maven")
            }
        }
        stage('deploy') {
            steps {
                script {
                    try {
                        timeout(time: 10, unit: 'MINUTES') {
                            env.useChoice = input(
                                message: "Can it be deployed?",
                                parameters: [choice(name: 'deploy',
                                                    choices: ['no', 'yes'],
                                                    description: 'Choose "yes" if you want to deploy')]

                            )
                        }
                        if (env.useChoice == 'yes') {
                            echo 'deploy'
                            sh(script: """ ${copyScript} """, label: "copy file .jar")
                            sh(script: """ ${permsScript} """, label: "set permission folder")
                            sh(script: """ ${killScript} """, label: "kill process")
                            sh(script: """ ${runScript} """, label: "run the project")
                        }
                        else {
                            echo "Do not confirm the deployment!"
                        }

                    } catch (Exception err) {

                    }
                }
            }
        }
    }
}
