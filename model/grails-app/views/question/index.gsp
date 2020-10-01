<%@ page import="br.ufscar.sead.loa.trivia.remar.Question" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Trivia</title>
    <link href="http://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
    <g:javascript src="iframeResizer.contentWindow.min.js"/>
</head>
<body>

<div class="cluster-header">
    <p class="text-teal text-darken-3 left-align margin-bottom" style="font-size: 28px;">
        <i class="small material-icons left">grid_on</i>Trivia - Banco de Questões
    </p>
</div>

<div class="row">
    <div id="chooseQuestion" class="col s12 m12 l12">
        <br>
        <div class="row">
            <div class="col s6 m3 l3 offset-s6 offset-m9 offset-l9">
                <input  type="text" id="SearchLabel" placeholder="Buscar"/>
            </div>
        </div>
        <div class="row">
            <div class="col s12 m12 l12">
                <table class="highlight" id="table" style="margin-top: -30px;">
                    <thead>
                    <tr>
                        <th>Selecionar
                            <div class="row" style="margin-bottom: -10px;">
                                <button style="margin-left: 3px; background-color: #795548" class="btn-floating " id="BtnCheckAll" onclick="check_all()"><i  class="material-icons">check_box_outline_blank</i></button>
                                <button style="margin-left: 3px; background-color: #795548" class="btn-floating " id="BtnUnCheckAll" onclick="uncheck_all()"><i  class="material-icons">done</i></button>
                            </div>
                        </th>
                        <th style="cursor: pointer;" id="statementLabel">Pergunta <div class="row" style="margin-bottom: -10px;"><button  class="btn-floating" style="visibility: hidden"></button></div></th>
                        <th style="cursor: pointer;" id="answerLabel">Respostas <div class="row" style="margin-bottom: -10px;"><button  class="btn-floating" style="visibility: hidden"></button></div></th>
                        <th style="cursor: pointer;" id="correctAnswerLabel">Alternativa Correta <div class="row" style="margin-bottom: -10px;"><button  class="btn-floating" style="visibility: hidden"></button></div></th>
                        <th>Ações <div class="row" style="margin-bottom: -10px;"><button  class="btn-floating" style="visibility: hidden"></button></div></th>
                    </tr>
                    </thead>

                    <tbody>
                    <g:each in="${questionInstanceList}" status="i" var="questionInstance">
                        <tr id="tr${questionInstance.id}" class="selectable_tr" style="cursor: pointer;"
                            data-id="${questionInstance.id}" data-owner-id="${questionInstance.ownerId}"
                            data-checked="false">

                            <td class="_not_editable">
                                <input style="background-color: #727272" id="checkbox-${questionInstance.id}" class="filled-in" type="checkbox">
                                <label for="checkbox-${questionInstance.id}"></label>
                            </td>
                            <td>${fieldValue(bean: questionInstance, field: "title")}</td>
                            <td>${fieldValue(bean: questionInstance, field: "answers")}</td>
                            <td>${questionInstance.answers[questionInstance.correctAnswer]}</td>
                            <td> <i style="color: #7d8fff !important; margin-right:10px;" class="fa fa-pencil " onclick="_edit($(this.closest('tr')))" ></i>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="row">
            <!--div id="defineMaxQuestion" class="col s12 m7 l7">
            </div-->
            <div class="col s1 m1 l1 offset-s4">
                <a data-target="createModal" name="create" class="btn-floating btn-large waves-effect waves-light modal-trigger my-orange tooltipped" data-tooltip="Criar questão"><i class="material-icons">add</i></a>
            </div>
            <div class="col s1 offset-s1 m1 l1">
                <a onclick="_delete()" class=" btn-floating btn-large waves-effect waves-light my-orange tooltipped" data-tooltip="Excluir questão" ><i class="material-icons">delete</i></a>
            </div>
        </div>
    </div>
</div>

<div class="row">
    <div class="col s2">
        <button class="btn waves-effect waves-light my-orange" type="submit" name="save" id="submitButton" onclick="submit()">Enviar
            <i class="material-icons">send</i>
        </button>
    </div>

</div>


<div id="editModal" class="modal">
    <div class="modal-content">
        <h4>Editar Questão</h4>
        <div class="row">
          <g:form method="post"  action="update" resource="${questionInstance}">
                <div class="row">
                    <div class="input-field col s12">
                        <input id="editTitle" name="title" required="" type="text" length="250" maxlength="250">
                        <label id="labelTitle" class="active" for="editTitle">Pergunta</label>
                    </div>
                </div>

                <div class="row">
                    <div class="input-field col s9">
                        <input class="validate" id="editAnswers0" name="answers1" required="" maxlength="49" type="text" length="49">
                        <label id="labelAnswer1" class="active" for="editAnswers0">Alternativa 1</label>
                    </div>
                    <div class="col s2">
                        <input type="radio" id="editRadio0" name="correctAnswer" value="0" />
                        <label for="editRadio0">Alternativa correta</label>
                    </div>
                </div>

                <div class="row">
                    <div class="input-field col s9">
                        <input class="validate" id="editAnswers1" name="answers2" required="" maxlength="49" type="text" length="49">
                        <label id="labelAnswer2" class="active" for="editAnswers1">Alternativa 2</label>
                    </div>
                    <div class="col s2">
                        <input type="radio" id="editRadio1" name="correctAnswer" value="1" /> <label for="editRadio1">Alternativa correta</label>
                    </div>
                </div>

                <div class="row">
                    <div class="input-field col s9">
                        <input class="validate" id="editAnswers2" name="answers3" required="" maxlength="49" type="text" length="49">
                        <label id="labelAnswer3" class="active" for="editAnswers2">Alternativa 3</label>
                    </div>
                    <div class="col s2">
                        <input type="radio" id="editRadio2" name="correctAnswer" value="2" /> <label for="editRadio2">Alternativa correta</label>
                    </div>
                </div>

                <div class="row">
                    <div class="input-field col s9">
                        <input class="validate" id="editAnswers3" name="answers4" required="" maxlength="49" type="text" length="49">
                        <label id="labelAnswer4" class="active" for="editAnswers3">Alternativa 4</label>
                    </div>
                    <div class="col s2">
                        <input type="radio" id="editRadio3" name="correctAnswer" value="3" /> <label for="editRadio3">Alternativa correta</label>
                    </div>
                </div>

                <input type="hidden" id="questionID" name="questionID">
                <g:submitButton name="update" class="btn btn-success btn-lg my-orange" value="Salvar" />
            </g:form>
        </div>
    </div>
</div>

<div id="createModal" class="modal">
    <div class="modal-content">
        <h4>Criar Questão</h4>
        <div class="row">
            <g:form action="save" resource="${questionInstance}">
                <div class="row">
                    <div class="input-field col s12">
                        <label for="title">Pergunta</label>
                        <input id="title" name="title" required=""  type="text" class="validate" maxlength="250" length="250">
                    </div>
                </div>

                <div class="row">
                    <div class="input-field col s9">
                        <input id="answers0" type="text" name="answers1" required maxlength="49" length="49">
                        <label for="answers0">Alternativa 1</label>
                    </div>

                    <div class="col s2">
                        <input type="radio" id="radio0" name="correctAnswer" value="0" />
                        <label for="radio0">Alternativa correta</label>
                    </div>
                </div>

                <div class="row">
                    <div class="input-field col s9">
                        <input id="answers1" type="text" name="answers2" required maxlength="49" length="49">
                        <label for="answers1">Alternativa 2</label>
                    </div>
                    <div class="col s2">
                        <input type="radio" id="radio1" name="correctAnswer" value="1" /> <label for="radio1">Alternativa correta</label>
                    </div>
                </div>

                <div class="row">
                    <div class="input-field col s9">
                        <input id="answers2" type="text" name="answers3" required maxlength="49" length="49">
                        <label for="answers2">Alternativa 3</label>
                    </div>
                    <div class="col s2">
                        <input type="radio" id="radio2" name="correctAnswer" value="2" /> <label for="radio2">Alternativa correta</label>
                    </div>
                </div>

                <div class="row">
                    <div class="input-field col s9">
                        <input id="answers3" type="text" name="answers4" required maxlength="49" length="49">
                        <label for="answers3">Alternativa 4</label>
                    </div>
                    <div class="col s2">
                        <input type="radio" id="radio3" name="correctAnswer" value="3" /> <label for="radio3">Alternativa correta</label>
                    </div>
                </div>
                <input type="hidden" name="taskId"  value="2" >

                <g:submitButton name="create" class="btn btn-success btn-lg my-orange" value="Criar" />
            </g:form>
        </div>
    </div>
</div>

<!-- Modal Structure -->
<div id="infoModal" class="modal">
    <div class="modal-content">
        <div id="totalQuestion">
            Este é o modal Informações

        </div>
    </div>
    <div class="modal-footer">
        <button class="btn waves-effect waves-light modal-close my-orange">Entendi</button>
    </div>
</div>

<script>
    $(document).ready(function() {
        $("#title").characterCounter();
    });
</script>
<script type="text/javascript" src="/trivia/js/questions.js"></script>
</body>
</html>

