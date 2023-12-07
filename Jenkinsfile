pipeline {
    agent any

    environment {
        MY_VARIABLE = 'Hello, World!' // Это ваша переменная
        DOCKER_TAG = "v${env.BUILD_NUMBER}" // Используем номер сборки в качестве тега Docker
    }

    stages {
        stage('Remove Old Docker Images') {
            steps {
                script {
                    sshagent(['ssh-credentials-id']) {
                        // Получаем список тегов образов и сортируем их
                        def tags = sh(script: "ssh -o StrictHostKeyChecking=no jenkins@192.168.66.191 'docker images my-node-js-app --format \"{{.Tag}}\"'", returnStdout: true).trim().split('\n')
                        tags = tags.collect { it.replaceAll(/^v/, "").trim() }

                        // Определяем количество тегов, которые вы хотите сохранить
                        def keepCount = 3

                        // Удаляем лишние теги
                        if (tags.size() > keepCount) {
                            def tagsToRemove = tags.take(tags.size() - keepCount)
                          //  def minTag = tagsToRemove.collect { it.toInteger() }.sort()[0]
                            def min = tagsToRemove[0].toInteger()
                            tagsToRemove.each { tag ->
                                    if (tag.toInteger() < min) {
                                        min = tag.toInteger()
                                    }
                                }
                            sh "ssh -o StrictHostKeyChecking=no jenkins@192.168.66.191 'docker rmi my-node-js-app:v${min}'"    
                            }
                        }
                    }
                }
            }
        stage('Stop and Remove Docker Container') {
            steps {
                script {
                    sshagent(['ssh-credentials-id']) {
                        // Остановка и удаление запущенного контейнера
                        sh "ssh -o StrictHostKeyChecking=no jenkins@192.168.66.191 'docker stop my-node-js-app || true && docker rm my-node-js-app || true'"
                    }
                }
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    // Проверяем, существует ли папка проекта, и если нет, клонируем репозиторий
                    sshagent(['ssh-credentials-id']) {
                        sh "ssh -o StrictHostKeyChecking=no jenkins@192.168.66.191 'rm -rf 1_simple_cicd_web && git clone https://github.com/vpob210/1_simple_cicd_web.git'"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sshagent(['ssh-credentials-id']) {
                        sh "ssh -o StrictHostKeyChecking=no jenkins@192.168.66.191 'cd 1_simple_cicd_web && docker build -t my-node-js-app:${DOCKER_TAG} . && docker run -d -p 99:3000 --name my-node-js-app my-node-js-app:${DOCKER_TAG}'"
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Value of MY_VARIABLE in the 'always' block: ${MY_VARIABLE}"
        }
    }
}
