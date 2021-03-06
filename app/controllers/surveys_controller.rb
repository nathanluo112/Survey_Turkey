get '/' do
  redirect '/surveys'
end

get '/surveys' do
  @surveys = Survey.all
  erb :"surveys/index"

end

get '/surveys/new' do
  if logged_in?
    erb :"surveys/new",layout: !request.xhr?
  else
    redirect '/sessions/new'
  end
end

put '/surveys/:id' do
  question_answers = params.select{|key,value| key.match(/question/)}
  question_answers.each do |question_index, answer_id|
    answer = Answer.find(answer_id)
    current_user.answers << answer
  end
  redirect "/surveys/#{params[:id]}/result"
end


post '/surveys' do
  if logged_in?
    @survey = current_user.surveys.build(title: params[:title], description: params[:description], user: current_user)
    @questions = params.select{|key,value| key.match(/q\d+\z/)}
    @answers = params.select{|key,value| key.match(/q\d+-/)}

    if @survey.save && !invalid_collection?(@questions) && !invalid_collection?(@answers)
      @survey.generate_survey(@questions, @answers)
      redirect "/users/#{current_user.id}"
    elsif @survey.persisted?
      @survey.destroy
    end
    erb :"surveys/repopulate"

  else
    redirect '/'
  end
end

delete '/surveys/:id' do
  survey = Survey.find(params[:id])
  if survey.destroy
    redirect "/users/#{current_user.id }"
  else
    @user = survey.user
    @surveys = @user.surveys
    @errors = survey.errors.full_messages
    erb :"users/surveys"
  end

end

get '/surveys/:id/result' do
  survey=Survey.find(params[:id])
  @survey_results=survey.compile_survey_result

  if request.xhr?
    erb :"surveys/detail", layout:false
  else
    erb :"surveys/detail"
  end
end

get '/surveys/:id' do
  if logged_in?
    @survey = Survey.find(params[:id])
    if !@survey.already_answered?(current_user.id)
      erb :"surveys/take"
    else
      redirect "/surveys/#{params[:id]}/result"
    end
  else
    erb :"sessions/new"
  end
end

