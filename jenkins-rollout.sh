node('testhan') {
  stage('git clone') {
    git url: "https://github.com/pyzhaoxd/jenkins-rollout"
    sh "ls -al"
    sh "pwd"
}
  stage('select env') {
    def envInput = input(
      id: 'envInput',
      message: 'Choose a deploy environment',
      parameters: [
         [
             $class: 'ChoiceParameterDefinition',
             choices: "devlopment\nqatest\nproduction",
             name: 'Env'
         ]
     ]
)
echo "This is a deploy step to ${envInput}"
sh "sed -i 's/<namespace>/${envInput}/' getVersion.sh"
sh "sed -i 's/<namespace>/${envInput}/' rollout.sh"
sh "bash getVersion.sh"
// env.WORKSPACE = pwd()
// def version = readFile "${env.WORKSPACE}/version.csv"
// println version
}
  stage('select version') {
     env.WORKSPACE = pwd()
  def version = readFile "${env.WORKSPACE}/version.csv"
  println version
      def userInput = input(id: 'userInput',
                                        message: '选择回滚版本',
                                        parameters: [
            [
                 $class: 'ChoiceParameterDefinition',
                 choices: "$version\n",
                 name: 'Version'
       ]
      ]
)
       sh "sed -i 's/<version>/${userInput}/' rollout.sh"
}
  stage('rollout deploy') {
      sh "bash rollout.sh"
}
}
