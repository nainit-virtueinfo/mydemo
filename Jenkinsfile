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
                    // Stop and remove any container running on port 3000
                    sh """
                    CONTAINER_ID=\$(docker ps -q --filter "ancestor=${registry}" --filter "publish=3000")
                    if [ "\$CONTAINER_ID" != "" ]; then
                        echo "Stopping and removing existing container..."
                        docker stop \$CONTAINER_ID
                        docker rm \$CONTAINER_ID
                    fi
                    """
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run the new container
                    sh "sudo docker run -dp 3000:3000 ${registry}:${commitHash}"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', registryCredential) {
                        sh "docker push ${registry}:${commitHash}"
                    }
                }
            }
        }
    }
}
