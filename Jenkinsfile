pipeline {
    agent any

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', daysToKeepStr: '5'))
        timestamps()
    }

    environment {
        registry = "nainitkalariya/mydemo"
        registryCredential = 'dockerhub'
        commitHash = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
    }

    stages {

        stage('Build Docker Image') {
            steps {
                script {
                    sh "sudo docker build -t ${registry}:${commitHash} ."
                }
            }
        }

        stage('Stop and Remove Old Container') {
            steps {
                script {
                    sh """
                    CONTAINER_ID=\$(sudo docker ps -q --filter "ancestor=${registry}:${commitHash}" --filter "publish=3000")
                    if [ -n "\$CONTAINER_ID" ]; then
                        echo "Stopping and removing existing container..."
                        sudo docker stop \$CONTAINER_ID
                        sudo docker rm \$CONTAINER_ID
                    else
                        echo "No container found using image ${registry}:${commitHash} or port 3000."
                    fi
                    """
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "sudo docker run -dp 3000:3000 ${registry}:${commitHash}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', registryCredential) {
                        sh "sudo docker push ${registry}:${commitHash}"
                    }
                }
            }
        }
    }
}
