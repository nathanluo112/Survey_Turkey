function formCreation(){
  var formsContainer = $(".forms-container");

  $("#add-question").on("click", function(event){
    event.preventDefault();

    $.ajax({
      method: 'get',
      url: '/questions/new'
    }).done(function(questionForm){

      formsContainer.append(questionForm);

      var question_index = "q" + formsContainer.children().length
      var answer_index = question_index + "-1"

      formsContainer.children().last().find("label").html("Question " + formsContainer.children().length);
      formsContainer.find("input[placeholder|='Question']").last().attr({'name': question_index});
      formsContainer.find("input[placeholder|='Answer']").last().attr({'name': answer_index});
      var questionIndexTitle = "Question " + formsContainer.children().length;
      formsContainer.children().last().find("label").html(questionIndexTitle);
    }).fail(function(error){
    });
  });


  $("#add-answer").on("click", function(event){
    event.preventDefault();

    $.ajax({
      method: 'get',
      url: '/answers/new'
    }).done(function(answerForm){

      var answersForm = formsContainer.find(".answer-form").last();

      answersForm.append(answerForm);
      var question_index = "q" + formsContainer.children().length;
      var answer_index = question_index + "-" + answersForm.children().length;

      answersForm.children().last().attr({'name': answer_index});
    })
  });

  $("#undo-add").on("click", function(event){
    event.preventDefault();


    var lastQuestionForm = formsContainer.children().last();
    if (lastQuestionForm.find(".answer-form").children().length == 1) {
      lastQuestionForm.remove();
    } else {
      var lastAnswerForm = lastQuestionForm.find("input[placeholder|='Answer']").last();
      lastAnswerForm.remove();
    }
  })
}

$(document).ready(formCreation);
