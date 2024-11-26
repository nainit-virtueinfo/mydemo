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
                    # Find the container using the current image and tag
                    CONTAINER_ID=\$(sudo docker ps -q --filter "ancestor=${registry}:${commitHash}")
                    
                    if [ -n "\$CONTAINER_ID" ]; then
                        echo "Stopping and removing container with tag ${commitHash}..."
                        sudo docker stop \$CONTAINER_ID
                        sudo docker rm \$CONTAINER_ID
                    else
                        echo "No container found using image ${registry}:${commitHash}."
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
