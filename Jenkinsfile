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

        stage('Run Docker Container') {
            steps {
                script {
                    // Stop and remove any container using the same image
                    sh """
                    docker ps -q --filter "ancestor=${registry}:${commitHash}" | xargs -r docker stop
                    docker ps -aq --filter "ancestor=${registry}:${commitHash}" | xargs -r docker rm
                    """
                    // Run the new container
                    sh "sudo docker run -dp 8080:3000 ${registry}:${commitHash}"
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
