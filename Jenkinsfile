pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                retry(2) {
                    git branch: 'main',
                        url: 'https://github.com/Zeshay/django-notes-app.git'
                }
            }
        }

        stage('Create Virtual Environment and Install Dependencies') {
            steps {
                sh '''#!/bin/bash
                    set -e
                    echo "Creating virtual environment..."
                    python3 -m venv venv
                    echo "Activating environment and installing dependencies..."
                    source venv/bin/activate
                    pip install --upgrade pip
                    pip install -r requirements.txt
                '''
            }
        }

        stage('Run Django App') {
            steps {
                sh '''#!/bin/bash
                    set -e
                    source venv/bin/activate
                    python manage.py migrate
                    gunicorn notesapp.wsgi:application --bind 0.0.0.0:8000
                '''
            }
        }
    }
}

