/**
 * Created by marcus on 30/03/16.
 */

window.onload = function(){
    $('#BtnUnCheckAll').hide();
    $('.modal-trigger').leanModal();
    $("#SearchLabel").keyup(function(){
        _this = this;
        $.each($("#table tbody ").find("tr"), function() {
            //console.log($(this).text());
            if($(this).text().toLowerCase().indexOf($(_this).val().toLowerCase()) == -1)
                $(this).hide();
            else
                $(this).show();
        });
    });

};


function submit(){
    var list_id = [];
    $.each($("input[type=checkbox]:checked"), function (ignored, el) {
        var tr = $(el).parents().eq(1);
        list_id.push($(tr).attr('data-id'));
    });

    //Chama controlador para salvar questões em arquivos.json
    $.ajax({
        type: "POST",
        traditional: true,
        url: "/trivia/question/exportQuestions",
        data: { list_id: list_id },
        success: function(returndata) {
            window.top.location.href = returndata;
        },
        error: function(returndata) {
            alert("Error:\n" + returndata.responseText);
        }
    });
}

function _edit(tr){
    var url = location.origin + '/trivia/question/returnInstance/' + $(tr).attr('data-id');
    var data = {_method: 'GET'};

    $.ajax({
            type: 'GET',
            data: data,
            url: url,
            success: function (returndata) {
                var questionInstance = returndata.split("%@!");
                //questionInstance é um vetor com os atributos da classe Question na seguinte ordem:
                // Title - Answer[0] - Answer[1] - Answer[2] - Answer[3] - correctAnswer - ID

                console.log("Sucesso?");
                console.log(questionInstance);

                switch(questionInstance[5]){
                    case '0':
                        $("#editRadio0").attr("checked","checked");
                        break;
                    case '1':
                        $("#editRadio1").attr("checked","checked");
                        break;
                    case '2':
                        $("#editRadio2").attr("checked","checked");
                        break;
                    case '3':
                        $("#editRadio3").attr("checked","checked");
                        break;
                    default :
                        console.log("Alternativa correta inválida");
                }
                $("#editTitle").attr("value",questionInstance[0]);
                $("#labelTitle").attr("class","active");
                $("#labelAnswer1").attr("class","active");
                $("#labelAnswer2").attr("class","active");
                $("#labelAnswer3").attr("class","active");
                $("#labelAnswer4").attr("class","active");
                $("#editAnswers0").attr("value",questionInstance[1]);
                $("#editAnswers1").attr("value",questionInstance[2]);
                $("#editAnswers2").attr("value",questionInstance[3]);
                $("#editAnswers3").attr("value",questionInstance[4]);
                $("#questionID").attr("value",questionInstance[6]);
                $("#editModal").openModal();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log("Error, não retornou a instância");
            }
        }
    );
}

function _delete() {
    var list_id = [];
    var url;
    var data;
    var trID;

    $.each($("input[type=checkbox]:checked"), function(ignored, el) {
        var tr = $(el).parents().eq(1);
        list_id.push($(tr).attr('data-id'));
    });

    if(list_id.length<=0){
        alert("Você deve selecionar ao menos uma questão para excluir");
    }
    else{
        if(list_id.length==1){
            if(confirm("Você tem certeza que deseja deletar essa questão?")){
                url = location.origin + '/trivia/question/delete/' + list_id[0];
                data = {_method: 'DELETE'};
                trID = "#tr"+list_id[0];
                $.ajax({
                        type: 'DELETE',
                        data: data,
                        url: url,
                        success: function (data) {
                            $(trID).remove();
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                        }
                    }
                );
            }
        }
        else{
            if(confirm("Você tem certeza que deseja deletar essas questões?")){
            for(var i=0;i<list_id.length;i++){
                    url = location.origin + '/trivia/question/delete/' + list_id[i];
                    data = {_method: 'DELETE'};
                    trID = "#tr"+list_id[i];
                    $(trID).remove();
                $.ajax({
                            type: 'DELETE',
                            data: data,
                            url: url,
                            success: function (data) {
                            },
                            error: function (XMLHttpRequest, textStatus, errorThrown) {
                            }
                        }
                    );
                }
                $(trID).remove();

            }
        }

    }

}

function check_all(){
    console.log("selecionar todas");
    var CheckAll = document.getElementById("BtnCheckAll");
    var trs = document.getElementById('table').getElementsByTagName("tbody")[0].getElementsByTagName('tr');
    $(".filled-in:visible").prop('checked', 'checked');


    for (var i = 0; i < trs.length; i++) {
        if($(trs[i]).is(':visible')) {
            $(trs[i]).attr('data-checked', "true");
        }
    }

    $('#BtnCheckAll').hide();
    $('#BtnUnCheckAll').show();

}

function uncheck_all(){
    console.log("remover todas");
    var UnCheckAll = document.getElementById("BtnUnCheckAll");
    var trs = document.getElementById('table').getElementsByTagName("tbody")[0].getElementsByTagName('tr');
    $(".filled-in:visible").prop('checked', false);


    for (var i = 0; i < trs.length; i++) {
        if($(trs[i]).is(':visible')) {
            $(trs[i]).attr('data-checked', "false");
        }
    }

    $('#BtnUnCheckAll').hide();
    $('#BtnCheckAll').show();

}