package br.ufscar.sead.loa.trivia.remar

class Question {

    String title
    String[] answers = new String[4]
    int correctAnswer
    long ownerId

    String taskId

    static constraints = {
    }
}
