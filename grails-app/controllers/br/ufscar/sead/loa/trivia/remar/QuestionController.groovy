package br.ufscar.sead.loa.trivia.remar

import br.ufscar.sead.loa.remar.api.MongoHelper
import grails.util.Environment
import grails.plugin.springsecurity.annotation.Secured
import org.springframework.web.multipart.MultipartFile

import static org.springframework.http.HttpStatus.*
import grails.transaction.Transactional

@Secured(["isAuthenticated()"])
class QuestionController {

    static allowedMethods = [save: "POST", update: "POST", delete: "DELETE", returnInstance: ["GET","POST"]]

    def beforeInterceptor = [action: this.&check, only: ['index']]

    def springSecurityService

    private check() {
        if (springSecurityService.isLoggedIn())
            session.user = springSecurityService.currentUser
        else {
            log.debug "Logout: session.user is NULL !"
            session.user = null
            redirect controller: "login", action: "index"

            return false
        }
    }

    @Secured(['permitAll'])
    def index() {
        if (params.t) {
            session.taskId = params.t
        }

        def list = Question.findAllByOwnerId(session.user.id)

        if(list.size()==0){
            println "Entrei aqui"
            new Question(title: "Questão 1", answers: ["Alternativa 1", "Alternativa 2", "Alternativa 3", "Alternativa 4"], correctAnswer: 0, ownerId:  session.user.id, taskId: session.taskId).save flush: true
            new Question(title: "Questão 2", answers: ["Alternativa 1", "Alternativa 2", "Alternativa 3", "Alternativa 4"], correctAnswer: 0, ownerId:  session.user.id, taskId: session.taskId).save flush: true
            new Question(title: "Questão 3", answers: ["Alternativa 1", "Alternativa 2", "Alternativa 3", "Alternativa 4"], correctAnswer: 0, ownerId:  session.user.id, taskId: session.taskId).save flush: true
            new Question(title: "Questão 4", answers: ["Alternativa 1", "Alternativa 2", "Alternativa 3", "Alternativa 4"], correctAnswer: 0, ownerId:  session.user.id, taskId: session.taskId).save flush: true
            new Question(title: "Questão 5", answers: ["Alternativa 1", "Alternativa 2", "Alternativa 3", "Alternativa 4"], correctAnswer: 0, ownerId:  session.user.id, taskId: session.taskId).save flush: true
        }
        respond Question.findAllByOwnerId(session.user.id), model: [questionInstanceCount: Question.count()]
    }
    def show(Question questionInstance) {
        respond questionInstance
    }
    def create() {
        respond new Question(params)
    }
    @Transactional
    def save(Question questionInstance) {
        if (questionInstance == null) {
            notFound()
            return
        }
        if (questionInstance.hasErrors()) {
            respond questionInstance.errors, view:'create'
            return
        }
        questionInstance.answers[0]= params.answers1
        questionInstance.answers[1]= params.answers2
        questionInstance.answers[2]= params.answers3
        questionInstance.answers[3]= params.answers4
        questionInstance.ownerId = session.user.id as long
        questionInstance.taskId = session.taskId as String
        questionInstance.save flush:true
        redirect(action: "index")
    }

    def edit(Question questionInstance) {
        respond questionInstance
    }

    @Transactional
    def update() {
        Question questionInstance = Question.findById(Integer.parseInt(params.questionID))
        questionInstance.title = params.title
        questionInstance.answers[0] = params.answers1
        questionInstance.answers[1] = params.answers2
        questionInstance.answers[2] = params.answers3
        questionInstance.answers[3] = params.answers4
        questionInstance.correctAnswer = Integer.parseInt(params.correctAnswer)
        questionInstance.ownerId = session.user.id as long
        questionInstance.taskId = session.taskId as String
        questionInstance.save flush:true
        redirect action: "index"
    }

    @Transactional
    def delete(Question questionInstance) {
        if (questionInstance == null) {
            notFound()
            return
        }
        questionInstance.delete flush: true
        render "delete ok!"
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'question.label', default: 'Question'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }

    def returnInstance(Question questionInstance){
        if (questionInstance == null) {
            notFound()
        }
        else{
            render questionInstance.title + "%@!" +
                    questionInstance.answers[0] + "%@!" +
                    questionInstance.answers[1] + "%@!" +
                    questionInstance.answers[2] + "%@!" +
                    questionInstance.answers[3] + "%@!" +
                    questionInstance.correctAnswer + "%@!" +
                    questionInstance.id
        }
    }

    @Transactional
    def exportQuestions(){

        // Criando a lista de questões

        ArrayList<Integer> list_questionId = new ArrayList<Integer>() ;
        ArrayList<Question> questionList = new ArrayList<Question>();
        list_questionId.addAll(params.list_id);
        for (int i = 0; i < list_questionId.size();i++){
            questionList.add(Question.findById(list_questionId[i]));
        }

        createJsonFile("Perguntas.json", questionList)

        def ids = []
        def folder = servletContext.getRealPath("/data/${session.user.id}/${session.taskId}")

        ids << MongoHelper.putFile(folder + '/Perguntas.json')

        def port = request.serverPort
        if (Environment.current == Environment.DEVELOPMENT) {
            port = 8080
        }

        render  "http://${request.serverName}:${port}/process/task/complete/${session.taskId}" +
                "?files=${ids[0]}"
    }

    void createJsonFile(String fileName, ArrayList<Question> questionList){
        int i = 0
        def dataPath = servletContext.getRealPath("/data")
        def instancePath = new File("${dataPath}/${springSecurityService.currentUser.id}/${session.taskId}")
        instancePath.mkdirs()

        File file = new File("$instancePath/"+fileName);
        def bw = new BufferedWriter(new OutputStreamWriter(
                new FileOutputStream(file), "UTF-8"))

        bw.write("{\"total_perguntas\":" + questionList.size + ", \"limite_erros\":3}\n")

        for (i = 0; i < questionList.size; i++) {
            bw.write("{\"pergunta\":")
            bw.write("\"" + questionList.getAt(i).title.replace("\"","\\\"") + "\", ")
            bw.write("\"respostas\":[")
            for (int j = 0; j < 4; j++) {
                bw.write("[" + (j+1) + ",")
                bw.write("\"" + questionList.getAt(i).answers[j].replace("\"","\\\"") + "\",")
                bw.write((questionList.getAt(i).correctAnswer == j ? "1" : 0) + "]")
                if (j != 3) bw.write(",")
            }
            bw.write("]}\n");
        }
        bw.close();
    }
}
