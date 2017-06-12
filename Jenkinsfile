
pipeline {
    agent {
        label 'linux'
    }
    stages {
        stage('Lint') {
            steps {
                wrap([$class: 'AnsiColorBuildWrapper']) {
                    sh 'foodcritic .'
                    sh 'rubocop --color -r cookstyle'
                }
            }
        }
        stage('Knife Upload') {
            when { branch "master" }
            steps {
                echo 'Uploading cookbook to Chef master...'
                wrap([$class: 'AnsiColorBuildWrapper']) {
                    sh "berks install && berks upload --ssl-verify=false"
                }
            }
        }
    }
}
