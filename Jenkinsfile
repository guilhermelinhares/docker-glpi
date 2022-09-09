pipeline {
    agent any

    stages {
        stage('Collect Variables') {
            steps {
                echo 'Version Choice is:' ${VERSION}
                echo 'Branch or Tag Choice is:' ${BRANCH_TAG}
            }
        }
    }
}
