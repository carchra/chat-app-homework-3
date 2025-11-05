pipeline {
    agent any

    environment {
        // Docker Hub credentials ID stored in Jenkins
        DOCKERHUB_CREDENTIALS ='Docker-Token'
        IMAGE_NAME ='batinthehat/homework-03'
    }

    stages {

        stage('Cloning Git') {
            steps {
                checkout scm
            }
        }

        stage('SAST') {
            steps {
                sh 'echo Running SAST scan...'
            }
        }

	stage('SonarQube Analysis') {
            agent {
                label 'Thing-1'
            }
            steps {
                script {
                    def scannerHome = tool 'SonarQube-Scanner'
                    withSonarQubeEnv('SonarQube-installation') {
                        sh "${scannerHome}/bin/sonar-scanner \
                            -Dsonar.projectKey=gameapp \
                            -Dsonar.sources=."
                    }
                }
            }
        }

      stage('BUILD-AND-TAG') {
            agent {
                label 'Thing-1'
            }
            steps {
                script {
                    // Build Docker image using Jenkins Docker Pipeline API
                    echo "Building Docker image ${IMAGE_NAME}..."
                    app = docker.build("${IMAGE_NAME}")
                    app.tag("latest")
                }
            }
        }


        stage('POST-TO-DOCKERHUB') {    
            agent {
                label 'Thing-1'
            }
            steps {
                script {
                    echo "Pushing image ${IMAGE_NAME}:latest to Docker Hub..."
                    docker.withRegistry('https://registry.hub.docker.com', "${DOCKERHUB_CREDENTIALS}") {
                        app.push("latest")
                    }
                }
            }
        }

        stage('SECURITY-IMAGE-SCANNER') {
            steps {
                sh 'echo Scanning Docker image for vulnerabilities...'
            }
        }

        stage('Pull-image-server') {
            steps {
                sh 'echo Pulling image on server...'
            }
        }

        stage('DAST') {
            steps {
                sh 'echo Performing DAST scan...'
            }
        }

        stage('DEPLOYMENT') {    
            agent {
                label 'Thing-1'
            }
            steps {
                echo 'Starting deployment using docker-compose...'
                script {
                    dir("${WORKSPACE}") {
                        sh '''
                            docker compose down
                            docker compose up -d
                            docker ps
                        '''
                    }
                }
                echo 'Deployment completed successfully!'
            }
        }
    }  
}  
