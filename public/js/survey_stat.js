$(document).ready(function(){
  $('#user_survey_list').on("click",".user_survey_link",function(event){
    event.preventDefault();
    var targetUrl="/surveys/"+$(event.target).attr("data-surveyid")+"/result";
    $.ajax({
      method:"get",
      url:targetUrl
    }).done(function(result){
      var survey_id=$(event.target).attr("data-surveyid");
      $("#survey_collapse_"+survey_id).children().first().html(result);
    }).fail(function(error){
      console.log(error);
    })
  });
});
